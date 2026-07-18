#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/common.sh"

info "Installing OpenTelemetry Collector..."

check_prerequisites

ensure_workload_cluster

confirm_cluster

helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts >/dev/null 2>&1 || true

helm repo update

helm_install \
    opentelemetry-collector \
    open-telemetry/opentelemetry-collector \
    opentelemetry \
    "${SCRIPT_DIR}/values/opentelemetry-values.yaml"

wait_for_deployment \
    opentelemetry \
    opentelemetry-collector

echo
info "OpenTelemetry Pods"

kubectl get pods -n opentelemetry

echo

completed
