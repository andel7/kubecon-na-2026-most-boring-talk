#!/usr/bin/env bash
# Simulates losing the cluster where Argo CD runs: every Application and ApplicationSet
# disappears, but the workloads they deployed keep running. Nothing manages them any more.
# Usage: disaster.sh [--quiet]
source "$(dirname "$0")/lib.sh"
require_cluster

quiet=false; [[ "${1:-}" == "--quiet" ]] && quiet=true

if ! ${quiet}; then
  echo
  bold "🔥🔥🔥  The cluster running Argo CD just died  🔥🔥🔥"
  echo
fi

info "Deleting every Application and ApplicationSet"

# Delete the root app first, so it can't recreate the apps it manages while they are being deleted.
kubectl -n argocd delete applications.argoproj.io root --ignore-not-found

# Deleting an ApplicationSet also deletes the apps it generated.
kubectl -n argocd delete applicationsets.argoproj.io --all

# Apps without a deletion finalizer leave their workloads running. An app with one (for example,
# the UI's "Set Deletion Finalizer" checkbox) takes its workloads down with it.
kubectl -n argocd delete applications.argoproj.io --all

echo
if ${quiet}; then
  ok "All Applications deleted. The workloads are still running."
else
  warn "Argo CD doesn't know about any of your apps any more."
  warn "They are still running, but nothing syncs, self-heals or tracks how they were configured."
  echo
  info "Still running:"
  kubectl get deployments --all-namespaces | grep -v -E '^(argocd|kube-system|local-path-storage) '
fi
