#!/usr/bin/env bash
# The recovery runbook: stop Backstage, start a fresh Postgres, load the newest backup,
# start Backstage again. Prints how long the portal was down (RTO) and what was lost (RPO).
source "$(dirname "$0")/lib.sh"
require_cluster

backup="$(newest_backup)"
[[ -n "${backup}" ]] || fail "No backup in backups/. Did you run 'make backup' in Part 1?"
stamp="$(basename "${backup}" .sql)"

start=$(date +%s)
bold "Restoring backups/${stamp}.sql"

info "Step 1/4: stop Backstage, so nothing writes while we restore"
kubectl -n "${NS}" scale deploy/backstage --replicas=0 >/dev/null
kubectl -n "${NS}" wait --for=delete pod -l app=backstage --timeout=120s >/dev/null 2>&1 || true

info "Step 2/4: start a fresh, empty Postgres on a new disk"
fresh_postgres

info "Step 3/4: load the backup with psql"
# The dump also drops and recreates the 'backstage' role, which psql is connected as.
# Skip those two lines; the fresh Postgres already has that role.
grep -vE '^(DROP ROLE IF EXISTS backstage;|CREATE ROLE backstage;)$' "${backup}" \
  | kubectl -n "${NS}" exec -i postgres-0 -- env PGOPTIONS="-c client_min_messages=warning" psql -q -v ON_ERROR_STOP=1 -d postgres >/dev/null

info "Step 4/4: start Backstage"
kubectl -n "${NS}" scale deploy/backstage --replicas=1 >/dev/null
wait_for_backstage
wait_for_catalog

echo
ok "Restored in $(( $(date +%s) - start ))s"
if [[ -f "${DISASTER_MARKER}" ]]; then
  disaster_at="$(cat "${DISASTER_MARKER}")"
  backup_at="$(date -u -j -f %Y%m%dT%H%M%SZ "${stamp}" +%s 2>/dev/null || date -u -d "$(sed -E 's/(....)(..)(..)T(..)(..)(..)Z/\1-\2-\3 \4:\5:\6/' <<<"${stamp}")" +%s)"
  bold "RTO (disaster until the portal was back): $(age $(( $(date +%s) - disaster_at )))"
  bold "RPO (backup age at the moment of the disaster): $(age $(( disaster_at - backup_at )))"
fi
