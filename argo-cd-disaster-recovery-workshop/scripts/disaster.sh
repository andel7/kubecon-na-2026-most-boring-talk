#!/usr/bin/env bash
# Deletes every Argo CD Application and ApplicationSet, and everything they deployed.
# Argo CD itself keeps running, but it no longer knows about any of your apps.
# Usage: disaster.sh [--quiet]
source "$(dirname "$0")/lib.sh"
require_cluster

quiet=false; [[ "${1:-}" == "--quiet" ]] && quiet=true
FINALIZER="resources-finalizer.argocd.argoproj.io"

if ! ${quiet}; then
  echo
  bold "🔥🔥🔥  Someone just ran 'kubectl delete applications --all'  🔥🔥🔥"
  echo
fi

# Argo CD only deletes an app's resources when the app has the resources finalizer.
# Apps created in the UI don't get it by default, so add it to every app first.
for app in $(kubectl -n argocd get applications.argoproj.io -o name); do
  kubectl -n argocd patch "${app}" --type merge -p "{\"metadata\":{\"finalizers\":[\"${FINALIZER}\"]}}" >/dev/null
done

# Delete the root app first, so it can't recreate the apps it manages while they are being deleted.
info "Deleting Applications, ApplicationSets and everything they deployed"
kubectl -n argocd delete applications.argoproj.io root --ignore-not-found --wait --timeout=180s
kubectl -n argocd delete applicationsets.argoproj.io --all --wait --timeout=180s
kubectl -n argocd delete applications.argoproj.io --all --wait --timeout=180s

# Namespaces created with CreateNamespace=true are not deleted with the app.
for ns in $(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'); do
  case "${ns}" in
    argocd|default|local-path-storage|kube-*) ;;
    *) kubectl delete namespace "${ns}" --wait --timeout=180s ;;
  esac
done

echo
if ${quiet}; then
  ok "All apps deleted. Argo CD is still running."
else
  warn "Every Application and everything it deployed is gone. Argo CD is still running, but it doesn't remember anything."
fi
