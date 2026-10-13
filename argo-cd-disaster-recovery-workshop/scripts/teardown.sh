#!/usr/bin/env bash
# Deletes the workshop cluster completely. Run 'make setup' to start again.
source "$(dirname "$0")/lib.sh"
kind delete cluster --name "${CLUSTER_NAME}"
ok "Cluster deleted"
