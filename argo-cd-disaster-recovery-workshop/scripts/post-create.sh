#!/usr/bin/env bash
# Codespaces setup: installs the CLIs the workshop needs on top of the dev container features.
# Runs from .devcontainer/argo-cd-dr-workshop/devcontainer.json at the repository root.
set -euo pipefail

source "$(dirname "$0")/versions.env"

ARCH="$(dpkg --print-architecture)" # amd64 or arm64

echo "==> Installing jq"
sudo apt-get update -qq && sudo apt-get install -y -qq jq >/dev/null

echo "==> Installing kind ${KIND_VERSION}"
curl -fsSLo /tmp/kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-${ARCH}"
sudo install -m 0755 /tmp/kind /usr/local/bin/kind

echo "==> Installing argocd CLI ${ARGOCD_VERSION}"
curl -fsSLo /tmp/argocd "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-${ARCH}"
sudo install -m 0755 /tmp/argocd /usr/local/bin/argocd

echo "==> Tool versions"
kind version
kubectl version --client
helm version --short
argocd version --client --short
jq --version

echo
echo "Tools installed. Next: creating the workshop cluster and installing Argo CD."
