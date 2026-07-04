#!/bin/bash

set -e

echo "===================================="
echo "Installing ArgoCD..."
echo "===================================="

helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
helm repo update

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --wait \
  --timeout 10m

echo ""
echo "ArgoCD Installed Successfully"

kubectl get pods -n argocd
