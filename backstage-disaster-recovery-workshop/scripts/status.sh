#!/usr/bin/env bash
# Shows the state of the lab as numbers: is the portal up, and what does Backstage have?
source "$(dirname "$0")/lib.sh"
require_cluster

pg_started="$(kubectl -n "${NS}" get pod postgres-0 -o jsonpath='{.status.startTime}' 2>/dev/null || true)"
if [[ -n "${pg_started}" ]]; then
  pg_epoch="$(date -u -j -f %Y-%m-%dT%H:%M:%SZ "${pg_started}" +%s 2>/dev/null || date -u -d "${pg_started}" +%s)"
  pg="running for $(age $(( $(date +%s) - pg_epoch )))"
else
  pg="not running"
fi
if curl -fsS -o /dev/null --max-time 3 "${API}/.backstage/health/v1/readiness" 2>/dev/null \
  && api_get '/api/catalog/entities/by-query?limit=1' >/dev/null 2>&1; then
  backend="up"
else
  backend="DOWN (the portal and its API do not answer)"
fi

printf '  %-28s %s\n' "Postgres" "${pg}"
printf '  %-28s %s\n' "Backstage" "${backend}"
printf '  %-28s %s\n' "Catalog entities" "$(entity_count)"
printf '  %-28s %s\n' "Scaffolder tasks" "$(task_count)"
printf '  %-28s %s\n' "Registered locations" "$(location_count)"
if [[ -f "${DISASTER_MARKER}" ]]; then
  printf '  %-28s %s\n' "Time since disaster" "$(age $(( $(date +%s) - $(cat "${DISASTER_MARKER}") )))"
fi
newest="$(newest_backup)"
printf '  %-28s %s\n' "Newest backup" "${newest:+backups/$(basename "${newest}")}"
