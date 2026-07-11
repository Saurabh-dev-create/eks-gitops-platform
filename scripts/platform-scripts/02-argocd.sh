#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

require_context "platform-cluster"

log "Installing ArgoCD..."

setup_helm_repos

create_namespace argocd

helm upgrade --install argocd \
  argo/argo-cd \
  --namespace argocd \
  --values "${SCRIPT_DIR}/values/argocd-values.yaml" \
  --wait \
  --timeout 20m \
  --atomic

wait_for_deployment argocd argocd-server

success "ArgoCD installed successfully."
