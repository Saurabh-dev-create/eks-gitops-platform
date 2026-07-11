#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

info "Installing Kyverno..."

check_prerequisites
ensure_workload_cluster
confirm_cluster

helm repo add kyverno https://kyverno.github.io/kyverno >/dev/null 2>&1 || true
helm repo update

helm upgrade --install kyverno kyverno/kyverno \
    --namespace kyverno \
    --create-namespace \
    --wait

info "Waiting for Kyverno components..."

kubectl wait \
  --for=condition=Ready pod \
  --all \
  -n kyverno \
  --timeout=300s

echo
kubectl get pods -n kyverno
echo

completed
