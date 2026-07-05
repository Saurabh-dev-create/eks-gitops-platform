#!/bin/bash

set -e

echo "========================================"
echo " Installing Security Stack"
echo "========================================"

############################################
# Prerequisite Checks
############################################

command -v helm >/dev/null 2>&1 || {
    echo "ERROR: Helm is not installed."
    exit 1
}

command -v kubectl >/dev/null 2>&1 || {
    echo "ERROR: kubectl is not installed."
    exit 1
}

############################################
# Add Helm Repositories
############################################

echo
echo "Adding Helm repositories..."

helm repo add kyverno https://kyverno.github.io/kyverno 2>/dev/null || true
helm repo add falcosecurity https://falcosecurity.github.io/charts 2>/dev/null || true

helm repo update

############################################
# Create Namespace
############################################

echo
echo "Creating kyverno namespace..."

kubectl get namespace kyverno >/dev/null 2>&1 || \
kubectl create namespace kyverno

############################################
# Install Kyverno
############################################

echo
echo "----------------------------------------"
echo "Installing Kyverno..."
echo "----------------------------------------"

helm upgrade --install kyverno kyverno/kyverno \
    -n kyverno \
    --wait

kubectl rollout status deployment/kyverno-admission-controller \
    -n kyverno

kubectl rollout status deployment/kyverno-background-controller \
    -n kyverno

kubectl rollout status deployment/kyverno-reports-controller \
    -n kyverno

echo "✓ Kyverno Ready"

############################################
# Apply Kyverno Policies
############################################

echo
echo "----------------------------------------"
echo "Applying Kyverno Policies..."
echo "----------------------------------------"

kubectl apply -f security/kyverno/policies/

echo
echo "Installed Policies"

kubectl get clusterpolicy



############################################
# Install Falco
############################################

echo
echo "----------------------------------------"
echo "Installing Falco..."
echo "----------------------------------------"

kubectl get namespace falco >/dev/null 2>&1 || \
kubectl create namespace falco

helm upgrade --install falco \
    falcosecurity/falco \
    -n falco \
    -f security/falco/custom-values.yaml \
    --wait

kubectl rollout status daemonset/falco \
    -n falco

echo "✓ Falco Ready"

############################################
# Falcosidekick (Placeholder)
############################################

echo
echo "----------------------------------------"
echo "Falcosidekick"
echo "----------------------------------------"

echo "Falcosidekick installation will be enabled after Slack integration is finalized."

############################################
# Verification
############################################

echo
echo "========================================"
echo " Security Stack Ready"
echo "========================================"

echo
echo "Installed Components:"
echo "✓ Kyverno"
echo "✓ Kyverno Policies"

echo
echo "----------------------------------------"
echo "Kyverno Pods"
echo "----------------------------------------"

kubectl get pods -n kyverno

echo
echo "----------------------------------------"
echo "Cluster Policies"
echo "----------------------------------------"

kubectl get clusterpolicy

echo
echo "----------------------------------------"
echo "Helm Releases"
echo "----------------------------------------"

helm list -n kyverno

echo
echo "========================================"
echo " Security Installation Completed"
echo "========================================"
