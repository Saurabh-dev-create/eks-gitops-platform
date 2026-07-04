#!/bin/bash

set -e

echo "Creating Kind Cluster..."

kind create cluster \
  --name gitops-cluster \
  --image kindest/node:v1.34.0 \
  --config infrastructure/kind/kind-config.yaml

echo ""
echo "Cluster Created Successfully"

kubectl get nodes
