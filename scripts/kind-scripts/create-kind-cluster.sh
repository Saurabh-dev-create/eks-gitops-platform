#!/bin/bash

set -e

CLUSTER_NAME="gitops-cluster"

echo "========================================"
echo " Creating Kind Cluster"
echo "========================================"

if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "Cluster '${CLUSTER_NAME}' already exists."
    exit 0
fi

echo "Creating Kind cluster..."

kind create cluster \
  --name "${CLUSTER_NAME}" \
  --image kindest/node:v1.34.0 \
  --config infrastructure/kind/kind-config.yaml

echo
echo "Waiting for nodes to become Ready..."

kubectl wait \
  --for=condition=Ready nodes \
  --all \
  --timeout=20m 

echo
echo "Cluster created successfully."

echo
kubectl get nodes -o wide
