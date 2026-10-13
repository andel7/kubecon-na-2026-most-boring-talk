#!/usr/bin/env bash
# GitOps setup: configure Argo CD with the Helm values from Git, then apply the root Application.
source "$(dirname "$0")/lib.sh"
require_cluster

bold "Step 1/2: configure Argo CD with Helm, using gitops/argocd/values.yaml"
helm_install_argocd -f "${ROOT_DIR}/gitops/argocd/values.yaml"
wait_for_argocd
wait_for_ui

bold "Step 2/2: apply the root Application"
apply_root
wait_for_apps
cli_login
