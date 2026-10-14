#!/usr/bin/env bash
# Creates the workshop cluster and installs a plain Argo CD with Helm.
# Runs automatically when the Codespace is created; safe to run again.
source "$(dirname "$0")/lib.sh"

# If any step fails, say so loudly and leave a marker for 'make ui'.
set -E
rm -f "${SETUP_FAILED_MARKER}"
on_failure() {
  echo "Setup failed at: ${BASH_COMMAND}" >"${SETUP_FAILED_MARKER}"
  echo
  printf '\033[31m✘ The setup FAILED. Fix the error above, then run: make setup\033[0m\n' >&2
}
trap on_failure ERR

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
