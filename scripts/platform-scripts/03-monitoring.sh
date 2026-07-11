#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

require_context "platform-cluster"

log "Installing kube-prometheus-stack..."

setup_helm_repos

helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --version 87.12.4 \
  -f "${SCRIPT_DIR}/values/prometheus-values.yaml" \
  --wait \
  --timeout 20m \
  --atomic

log "Verifying monitoring stack..."

kubectl rollout status deployment/kube-prometheus-stack-operator \
  -n monitoring \
  --timeout=300s

success "Monitoring Stack Installed Successfully."
