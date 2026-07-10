#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

log "Installing Metrics Server..."

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm repo update

create_namespace kube-system

helm upgrade --install metrics-server \
metrics-server/metrics-server \
-n kube-system \
--wait

wait_for_deployment kube-system metrics-server

success "Metrics Server installed successfully."
