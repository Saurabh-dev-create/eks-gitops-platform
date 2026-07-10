#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

require_context "platform-cluster"

log "Installing kube-prometheus-stack..."

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --version 87.12.4 \
  -f values/prometheus-values.yaml \
  --wait \
  --timeout 20m \
  --atomic

log "Verifying monitoring stack..."

kubectl rollout status deployment/kube-prometheus-stack-operator \
  -n monitoring \
  --timeout=300s

success "Monitoring Stack Installed Successfully."
