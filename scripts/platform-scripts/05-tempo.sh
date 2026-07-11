#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

require_context "platform-cluster"

setup_helm_repos

log "Installing Tempo..."

helm upgrade --install tempo \
  grafana/tempo \
  --namespace monitoring \
  --create-namespace \
  -f "${SCRIPT_DIR}/values/tempo-values.yaml" \
  --wait \
  --timeout 20m

success "Tempo Installed Successfully."
