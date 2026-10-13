#!/usr/bin/env bash
# The whole GitOps recovery runbook: apply the root Application from Git.
# Argo CD then recreates every app the root app manages.
source "$(dirname "$0")/lib.sh"
require_cluster

start=$(date +%s)
bold "Recovering: kubectl apply -f gitops/bootstrap/root.yaml"
apply_root
wait_for_apps
echo
ok "Recovered in $(( $(date +%s) - start )) seconds"
