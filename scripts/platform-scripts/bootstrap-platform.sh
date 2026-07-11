#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "Enterprise Platform Bootstrap"
echo "======================================"

bash "${SCRIPT_DIR}/01-metrics-server.sh"

bash "${SCRIPT_DIR}/02-argocd.sh"

bash "${SCRIPT_DIR}/03-monitoring.sh"

bash "${SCRIPT_DIR}/04-loki.sh"

bash "${SCRIPT_DIR}/05-tempo.sh"

bash "${SCRIPT_DIR}/06-opentelemetry.sh"

echo ""
echo "======================================"
echo "Platform Bootstrap Completed"
echo "======================================"
