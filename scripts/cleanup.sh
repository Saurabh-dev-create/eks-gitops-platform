#!/bin/bash

set -euo pipefail

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

echo "========================================"
echo " Enterprise Platform Cleanup"
echo "========================================"
echo

echo "1) Delete Kind Cluster"
echo "2) Cleanup Platform Cluster"
echo "3) Cleanup Workload Cluster"
echo "4) Cleanup Everything"
echo "5) Exit"
echo

read -rp "Select option: " OPTION

cleanup_kind() {

    if ! command -v kind >/dev/null 2>&1; then
        return
    fi

    if kind get clusters | grep -q "^gitops-cluster$"; then
        info "Deleting Kind cluster..."
        kind delete cluster --name gitops-cluster
        success "Kind cluster deleted."
    else
        warn "Kind cluster not found."
    fi
}

cleanup_platform() {

    info "Cleaning Platform Cluster..."

    helm uninstall argocd -n argocd 2>/dev/null || true
    helm uninstall kube-prometheus-stack -n monitoring 2>/dev/null || true
    helm uninstall loki -n monitoring 2>/dev/null || true
    helm uninstall tempo -n monitoring 2>/dev/null || true
    helm uninstall opentelemetry -n monitoring 2>/dev/null || true

    kubectl delete ns argocd --ignore-not-found
    kubectl delete ns monitoring --ignore-not-found

    success "Platform cleanup complete."
}

cleanup_workload() {

    info "Cleaning Workload Cluster..."

    helm uninstall ingress-nginx -n ingress-nginx 2>/dev/null || true
    helm uninstall cert-manager -n cert-manager 2>/dev/null || true
    helm uninstall external-secrets -n external-secrets 2>/dev/null || true
    helm uninstall argo-rollouts -n argo-rollouts 2>/dev/null || true
    helm uninstall kyverno -n kyverno 2>/dev/null || true
    helm uninstall opentelemetry-agent -n monitoring 2>/dev/null || true

    kubectl delete ns ingress-nginx --ignore-not-found
    kubectl delete ns cert-manager --ignore-not-found
    kubectl delete ns external-secrets --ignore-not-found
    kubectl delete ns argo-rollouts --ignore-not-found
    kubectl delete ns kyverno --ignore-not-found

    success "Workload cleanup complete."
}

wait_lb() {

    info "Waiting for AWS LoadBalancers to disappear..."

    while kubectl get svc -A 2>/dev/null | grep -q LoadBalancer; do
        kubectl get svc -A | grep LoadBalancer
        sleep 15
    done

    success "No LoadBalancer services remaining."
}

echo
CURRENT=$(kubectl config current-context 2>/dev/null || echo "No cluster")

echo "Current Context:"
echo "$CURRENT"
echo

read -rp "Continue? (y/N): " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || exit 0

case $OPTION in

1)
    cleanup_kind
    ;;

2)
    cleanup_platform
    wait_lb
    ;;

3)
    cleanup_workload
    wait_lb
    ;;

4)
    cleanup_kind
    cleanup_platform
    cleanup_workload
    wait_lb
    ;;

5)
    exit 0
    ;;

*)
    error "Invalid option."
    exit 1
    ;;
esac

echo
success "Cleanup completed."
echo
warn "After LoadBalancers disappear, run:"
echo "terraform destroy"
