#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "${SCRIPT_DIR}/01-nginx-ingress.sh"

bash "${SCRIPT_DIR}/02-cert-manager.sh"

bash "${SCRIPT_DIR}/03-external-secrets.sh"

bash "${SCRIPT_DIR}/04-argo-rollouts.sh"

bash "${SCRIPT_DIR}/05-opentelemetry-agent.sh"

bash "${SCRIPT_DIR}/06-kyverno.sh"

bash "${SCRIPT_DIR}/07-verify-workload.sh"
