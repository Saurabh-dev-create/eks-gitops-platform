#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

require_context "platform-cluster"

setup_helm_repos

log "Installing Loki..."

helm upgrade --install loki \
  grafana/loki \
  --namespace monitoring \
  --version 5.48.0 \
  -f "${SCRIPT_DIR}/values/loki-values.yaml" \
  --wait \
  --timeout 20m 
  

success "Loki Installed Successfully."
