#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

check_prerequisites
ensure_workload_cluster

echo
echo "=============================================="
echo "      WORKLOAD CLUSTER VERIFICATION"
echo "=============================================="
echo

kubectl get nodes

echo
kubectl get pods -n ingress-nginx

echo
kubectl get pods -n cert-manager

echo
kubectl get pods -n external-secrets

echo
kubectl get pods -n kyverno

echo
kubectl get pods -n argo-rollouts

echo
kubectl get pods -n monitoring

echo
success "Workload Cluster Verification Completed"
