#!/bin/bash

set -e

echo "========================================"
echo " Installing ArgoCD"
echo "========================================"

# Check if Helm is installed
command -v helm >/dev/null 2>&1 || {
    echo "ERROR: helm is not installed."
    exit 1
}

# Check if kubectl is installed
command -v kubectl >/dev/null 2>&1 || {
    echo "ERROR: kubectl is not installed."
    exit 1
}

echo "Adding ArgoCD Helm repository..."

helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
helm repo update

echo
echo "Creating namespace..."

kubectl get namespace argocd >/dev/null 2>&1 || \
kubectl create namespace argocd
echo
echo "Installing ArgoCD..."

helm upgrade --install argocd argo/argo-cd \
    --namespace argocd \
    --wait

echo
echo "Waiting for ArgoCD components..."

kubectl wait \
    --for=condition=Available deployment \
    --all \
    -n argocd \
    --timeout=10m

echo
echo "========================================"
echo " ArgoCD Installed Successfully"
echo "========================================"

kubectl get pods -n argocd
