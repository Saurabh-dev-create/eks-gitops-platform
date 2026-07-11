#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

info "Installing Argo Rollouts..."

check_prerequisites
ensure_workload_cluster
confirm_cluster

helm repo add argo https://argoproj.github.io/argo-helm >/dev/null 2>&1 || true
helm repo update

helm upgrade --install argo-rollouts argo/argo-rollouts \
    --namespace argo-rollouts \
    --create-namespace \
    --wait

wait_for_deployment argo-rollouts argo-rollouts

echo
kubectl get pods -n argo-rollouts
echo

completed
