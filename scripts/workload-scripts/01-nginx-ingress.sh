#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/common.sh"

info "Installing NGINX Ingress Controller..."

check_prerequisites

ensure_workload_cluster

confirm_cluster

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null 2>&1 || true

helm repo update

helm_install \
    ingress-nginx \
    ingress-nginx/ingress-nginx \
    ingress-nginx \
    "${SCRIPT_DIR}/values/ingress-values.yaml"

wait_for_deployment \
    ingress-nginx \
    ingress-nginx-controller

echo
kubectl get pods -n ingress-nginx
echo

completed
