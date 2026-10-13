#!/usr/bin/env bash
# Creates the workshop cluster and installs a plain Argo CD with Helm.
# Runs automatically when the Codespace is created; safe to run again.
source "$(dirname "$0")/lib.sh"

if kind get clusters 2>/dev/null | grep -qx "${CLUSTER_NAME}"; then
  ok "Cluster '${CLUSTER_NAME}' already exists"
else
  info "Creating kind cluster '${CLUSTER_NAME}'"
  kind create cluster --name "${CLUSTER_NAME}" --config "${ROOT_DIR}/scripts/kind-config.yaml" --wait 120s
fi
kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null

if helm status argocd -n argocd >/dev/null 2>&1; then
  ok "Argo CD is already installed"
else
  info "Installing Argo CD ${ARGOCD_VERSION} with Helm (chart ${ARGOCD_CHART_VERSION})"
  helm_install_argocd -f "${ROOT_DIR}/scripts/clickops-values.yaml"
fi

wait_for_argocd
wait_for_ui
cli_login
echo
ok "All set. Continue with docs/01-clickops.md."
