#!/bin/bash

set -euo pipefail

############################################
# Colors
############################################

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

############################################
# Logging
############################################

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

############################################
# Dependency Checks
############################################

check_prerequisites() {

    command -v kubectl >/dev/null 2>&1 || {
        error "kubectl not found."
        exit 1
    }

    command -v helm >/dev/null 2>&1 || {
        error "helm not found."
        exit 1
    }

}

############################################
# Cluster Helpers
############################################

current_cluster() {
    kubectl config current-context
}

print_cluster() {

    echo
    echo "=========================================="
    echo "Current Cluster"
    echo "=========================================="

    current_cluster

    echo
}

############################################
# Safety Check
############################################

confirm_cluster() {

    print_cluster

    read -rp "Continue on this cluster? (y/N): " answer

    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
        warning "Operation cancelled."
        exit 0
    fi
}

############################################
# Ensure Workload Cluster
############################################

ensure_workload_cluster() {

    CLUSTER=$(current_cluster)

    case "$CLUSTER" in
        *dev-cluster|*stage-cluster|*prod-cluster|*dr-cluster)
            success "Workload cluster detected."
            ;;
        *)
            error "This script must run on a workload cluster."
            error "Current cluster: $CLUSTER"
            exit 1
            ;;
    esac

}

############################################
# Helm Helper
############################################

helm_install() {

    local RELEASE=$1
    local CHART=$2
    local NAMESPACE=$3
    local VALUES=$4

    helm upgrade --install "$RELEASE" "$CHART" \
        --namespace "$NAMESPACE" \
        --create-namespace \
        -f "$VALUES" \
        --wait
}

############################################
# Rollout Helper
############################################

wait_for_deployment() {

    local NAMESPACE=$1
    local DEPLOYMENT=$2

    kubectl rollout status deployment/"$DEPLOYMENT" \
        -n "$NAMESPACE" \
        --timeout=300s
}

############################################
# Finish Banner
############################################

completed() {

    echo
    success "Bootstrap step completed successfully."
    echo
}
