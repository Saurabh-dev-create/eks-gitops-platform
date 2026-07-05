#!/bin/bash

set -e

CLUSTER_NAME="gitops-cluster"

echo "========================================"
echo " Enterprise Platform Cleanup"
echo "========================================"

if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "Deleting Kind cluster: ${CLUSTER_NAME}"
    kind delete cluster --name "${CLUSTER_NAME}"
    echo "Cluster deleted successfully."
else
    echo "Cluster '${CLUSTER_NAME}' does not exist. Nothing to clean."
fi

echo
echo "Remaining Kind clusters:"
kind get clusters || true

echo
echo "Cleanup complete."
