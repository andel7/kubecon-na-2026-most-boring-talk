#!/usr/bin/env bash
# Puts the lab back to the state right after 'make setup', without recreating the cluster:
# deletes the namespace (Backstage, Postgres and its disk), the backups and the disaster time.
source "$(dirname "$0")/lib.sh"
require_cluster

start=$(date +%s)
info "Deleting everything in the '${NS}' namespace, including the Postgres disk"
kubectl delete namespace "${NS}" --ignore-not-found --wait=true >/dev/null
rm -rf "${BACKUP_DIR}" "${DISASTER_MARKER}"

info "Starting Postgres and Backstage again"
"${ROOT_DIR}/scripts/render-tour.sh"
apply_lab
ok "Reset done in $(( $(date +%s) - start ))s. Portal: $(base_url)"
