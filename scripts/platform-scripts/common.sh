#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}
require_context() {

    local expected="$1"
    local current

    current=$(kubectl config current-context)

    if [[ "$current" != *"$expected"* ]]; then
        error "Wrong Kubernetes context"

        echo "Current : $current"
        echo "Expected: $expected"

        exit 1
    fi
}
setup_helm_repos() {

    helm repo add argo https://argoproj.github.io/argo-helm >/dev/null 2>&1 || true
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
    helm repo add grafana https://grafana.github.io/helm-charts >/dev/null 2>&1 || true
    helm repo add kyverno https://kyverno.github.io/kyverno >/dev/null 2>&1 || true
    helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts >/dev/null 2>&1 || true
    helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server >/dev/null 2>&1 || true

    helm repo update
}
create_namespace() {

    local ns=$1

    kubectl create namespace "$ns" \
        --dry-run=client \
        -o yaml | kubectl apply -f -

}

wait_for_deployment() {

    local namespace=$1
    local deployment=$2

    kubectl rollout status deployment/"$deployment" \
        -n "$namespace" \
        --timeout=300s

}
