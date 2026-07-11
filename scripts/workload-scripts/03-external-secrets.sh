#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/common.sh"

info "Installing External Secrets..."

check_prerequisites

ensure_workload_cluster

confirm_cluster

helm repo add external-secrets https://charts.external-secrets.io >/dev/null 2>&1 || true

helm repo update

helm_install \
    external-secrets \
    external-secrets/external-secrets \
    external-secrets \
    "${SCRIPT_DIR}/values/external-secrets-values.yaml"

wait_for_deployment \
    external-secrets \
    external-secrets

echo
info "External Secrets Pods"

kubectl get pods -n external-secrets

echo

completed
