#!/bin/bash

set -e

echo "========================================"
echo " Installing Monitoring Stack"
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

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo add grafana https://grafana.github.io/helm-charts 2>/dev/null || true
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts 2>/dev/null || true

helm repo update

############################################
# Create Namespace
############################################

echo
echo "Creating monitoring namespace..."

kubectl get namespace monitoring >/dev/null 2>&1 || \
kubectl create namespace monitoring

############################################
# Install Prometheus + Grafana
############################################

echo
echo "----------------------------------------"
echo "Installing Prometheus & Grafana..."
echo "----------------------------------------"

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
    -n monitoring \
    -f observability/prometheus/values.yaml \
    --wait

kubectl rollout status deployment/monitoring-grafana \
    -n monitoring

echo "✓ Prometheus & Grafana Ready"

############################################
# Install Loki
############################################

echo
echo "----------------------------------------"
echo "Installing Loki..."
echo "----------------------------------------"

helm upgrade --install loki grafana/loki \
    -n monitoring \
    -f observability/loki/values.yaml \
    --wait

kubectl rollout status deployment/loki-gateway \
    -n monitoring

echo "✓ Loki Ready"

############################################
# Install Grafana Alloy
############################################

echo
echo "----------------------------------------"
echo "Installing Grafana Alloy..."
echo "----------------------------------------"

helm upgrade --install alloy grafana/alloy \
    -n monitoring \
    -f observability/alloy/values.yaml \
    --wait

kubectl rollout status daemonset/alloy \
    -n monitoring

echo "✓ Grafana Alloy Ready"

############################################
# Install Tempo
############################################

echo
echo "----------------------------------------"
echo "Installing Tempo..."
echo "----------------------------------------"

helm upgrade --install tempo grafana/tempo \
    -n monitoring \
    -f observability/tempo/values.yaml \
    --wait

kubectl rollout status statefulset/tempo \
    -n monitoring

echo "✓ Tempo Ready"

############################################
# Install OpenTelemetry Collector
############################################

echo
echo "----------------------------------------"
echo "Installing OpenTelemetry Collector..."
echo "----------------------------------------"

helm upgrade --install otel-collector \
    open-telemetry/opentelemetry-collector \
    -n monitoring \
    -f observability/opentelemetry/values.yaml \
    --wait

kubectl rollout status deployment/otel-collector-opentelemetry-collector \
    -n monitoring

echo "✓ OpenTelemetry Collector Ready"

############################################
# Verification
############################################

echo
echo "========================================"
echo " Monitoring Stack Ready"
echo "========================================"

echo
echo "Installed Components:"
echo "✓ Prometheus"
echo "✓ Grafana"
echo "✓ Loki"
echo "✓ Grafana Alloy"
echo "✓ Tempo"
echo "✓ OpenTelemetry Collector"

echo
echo "----------------------------------------"
echo "Pods"
echo "----------------------------------------"

kubectl get pods -n monitoring

echo
echo "----------------------------------------"
echo "Services"
echo "----------------------------------------"

kubectl get svc -n monitoring

echo
echo "----------------------------------------"
echo "Helm Releases"
echo "----------------------------------------"

helm list -n monitoring

echo
echo "========================================"
echo " Monitoring Installation Completed"
echo "========================================"



