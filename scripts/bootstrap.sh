#!/bin/bash

set -e

echo "========================================"
echo " Enterprise Platform Bootstrap"
echo "========================================"

echo
echo "[1/4] Creating Kind Cluster..."
./scripts/create-kind-cluster.sh

echo
echo "[2/4] Installing ArgoCD..."
./scripts/install-argocd.sh

echo
echo "[3/4] Installing Monitoring Stack..."
./scripts/install-monitoring.sh

echo
echo "[4/4] Installing Security Stack..."
./scripts/install-security.sh

echo
echo "========================================"
echo " Enterprise Platform Successfully Deployed"
echo "========================================"

echo
echo "Summary"

echo "✓ Kind Cluster"

echo "✓ ArgoCD"

echo "✓ Prometheus"

echo "✓ Grafana"

echo "✓ Loki"

echo "✓ Grafana Alloy"

echo "✓ Tempo"

echo "✓ OpenTelemetry Collector"

echo "✓ Kyverno"

echo
echo "Run the following commands to verify:"

echo "kubectl get nodes"

echo "kubectl get pods -A"

echo "helm list -A"

echo
echo "Platform deployment completed successfully."
