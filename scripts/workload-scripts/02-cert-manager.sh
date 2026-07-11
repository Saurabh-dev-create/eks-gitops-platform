#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/common.sh"

info "Installing Cert Manager..."

check_prerequisites

ensure_workload_cluster

confirm_cluster

helm repo add jetstack https://charts.jetstack.io >/dev/null 2>&1 || true

helm repo update

helm_install \
    cert-manager \
    jetstack/cert-manager \
    cert-manager \
    "${SCRIPT_DIR}/values/cert-manager-values.yaml"

wait_for_deployment \
    cert-manager \
    cert-manager

echo
info "Cert Manager Pods"

kubectl get pods -n cert-manager

echo

completed
