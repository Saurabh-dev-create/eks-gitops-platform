#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

log "Installing ArgoCD..."

helm repo add argo https://argoproj.github.io/argo-helm

helm repo update

create_namespace argocd

helm upgrade --install argocd \
  argo/argo-cd \
  --namespace argocd \
  --values values/argocd-values.yaml \
  --wait

wait_for_deployment argocd argocd-server

success "ArgoCD installed successfully."
