#!/usr/bin/env bash
# Shared helpers for the workshop scripts.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/scripts/versions.env"

# The one kind cluster used for the whole workshop.
CLUSTER_NAME="argocd-workshop"

# The Argo CD Helm chart ships with the repo, so installing it needs no download.
ARGOCD_CHART="${ROOT_DIR}/charts/argo-cd-${ARGOCD_CHART_VERSION}.tgz"

# Written by 'make setup' when it fails, so 'make ui' can say so instead of waiting.
SETUP_FAILED_MARKER="${HOME}/.argocd-workshop-setup-failed"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
info()  { printf '\033[36m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[32m✔\033[0m %s\n' "$*"; }
warn()  { printf '\033[33m!\033[0m %s\n' "$*"; }
fail()  { printf '\033[31m✘\033[0m %s\n' "$*" >&2; exit 1; }

require_cluster() {
  kubectl cluster-info >/dev/null 2>&1 || fail "No reachable cluster. Run 'make setup' first."
}

wait_for_argocd() {
  info "Waiting for Argo CD components to become ready"
  kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
  kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=300s
  kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s
  kubectl -n argocd rollout status deploy/argocd-applicationset-controller --timeout=300s
}

wait_for_ui() {
  info "Waiting for the Argo CD UI on http://localhost:8080"
  for _ in $(seq 1 60); do
    curl -fsS -o /dev/null http://localhost:8080/healthz 2>/dev/null && return 0
    sleep 2
  done
  fail "The Argo CD UI is not reachable on localhost:8080. Was the cluster created with 'make setup'?"
}

admin_password() {
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
}

cli_login() {
  local pass
  pass="$(admin_password)"
  # --grpc-web sends the CLI's gRPC calls as plain HTTP/1.1 requests, which work through any proxy.
  argocd login localhost:8080 --plaintext --grpc-web --username admin --password "${pass}" >/dev/null
  ok "argocd CLI logged in as admin"
  echo
  bold "Argo CD UI: http://localhost:8080 (in Codespaces: PORTS tab, port 8080)"
  bold "Username:   admin"
  bold "Password:   ${pass}"
}


# helm_install_argocd installs (or upgrades) Argo CD from the chart in charts/.
# Extra arguments are passed to helm, e.g. -f values.yaml.
helm_install_argocd() {
  helm upgrade --install argocd "${ARGOCD_CHART}" \
    --namespace argocd --create-namespace \
    "$@" >/dev/null
}

# wait_for_apps waits until every Application is Synced and Healthy.
wait_for_apps() {
  info "Waiting for Argo CD to sync everything from Git"
  local deadline apps count pending
  deadline=$(( $(date +%s) + 300 ))
  while :; do
    apps="$(kubectl -n argocd get applications.argoproj.io -o json)"
    count="$(jq '.items | length' <<<"${apps}")"
    pending="$(jq '[.items[] | select(.status.sync.status != "Synced" or .status.health.status != "Healthy")] | length' <<<"${apps}")"
    printf '\r  %s applications, %s still syncing   ' "${count}" "${pending}"
    if (( count > 1 && pending == 0 )); then echo; break; fi
    if (( $(date +%s) > deadline )); then echo; warn "Some applications are not healthy yet. Check the UI."; break; fi
    sleep 3
  done
  kubectl -n argocd get applications.argoproj.io
}

# apply_root applies the root Application from Git, the one object you create by hand.
apply_root() {
  if grep -q "CHANGE_ME" "${ROOT_DIR}/gitops/bootstrap/root.yaml"; then
    fail "gitops/bootstrap/root.yaml still points at CHANGE_ME. Run 'make configure' first."
  fi
  kubectl apply -f "${ROOT_DIR}/gitops/bootstrap/root.yaml"
}
