#!/bin/bash

set -e

echo "===================================="
echo "Installing kube-prometheus-stack..."
echo "===================================="

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo update

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f observability/prometheus/custom-values.yaml \
  --wait \
  --timeout 15m

echo ""
echo "===================================="
echo "Monitoring Stack Installed"
echo "===================================="

kubectl get pods -n monitoring
