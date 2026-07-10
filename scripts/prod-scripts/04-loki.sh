#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

require_context "platform-cluster"

setup_helm_repos

log "Installing Loki..."

helm upgrade --install loki \
grafana/loki \
-n monitoring \
-f values/loki-values.yaml \
--version 6.42.0 \
--wait \
--timeout 20m \
--atomic

success "Loki Installed Successfully."
