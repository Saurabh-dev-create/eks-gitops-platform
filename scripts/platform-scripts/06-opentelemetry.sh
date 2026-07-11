#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

require_context "platform-cluster"

setup_helm_repos

log "Installing OpenTelemetry Collector..."

helm upgrade --install opentelemetry \
  open-telemetry/opentelemetry-collector \
  --namespace monitoring \
  --create-namespace \
  -f "${SCRIPT_DIR}/values/opentelemetry-values.yaml" \
  --wait \
  --timeout 20m

success "OpenTelemetry Collector Installed Successfully."
