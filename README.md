# Enterprise Platform Engineering

Production-grade Platform Engineering stack implementing GitOps, observability, security policies, progressive delivery, and incident-ready operations on Kubernetes.
### Kind Cluster Verification

![Cluster Verification](docs/screenshots/01-kind-cluster/cluster.png)

*Fresh Kubernetes cluster showing only core system components before platform bootstrap, ensuring a clean and reproducible GitOps setup.*

### ArgoCD Bootstrap

![ArgoCD Components](docs/screenshots/02-argocd/argocd-components-running.png)

*Successfully deployed ArgoCD as the GitOps control plane. Verified that all core components—including the API server, application controller, repository server, Redis, Dex, notifications controller, and ApplicationSet controller—are running and healthy.*

### GitOps Application Deployment

![GitOps Sync](docs/screenshots/03-gitops-sync/argocd-nginx-demo-synced.png)

*Successfully deployed the nginx-demo application using ArgoCD GitOps. The application is synchronized with the Git repository and automatically reconciled to the desired state stored in version control.*

**Key Features Demonstrated**

* Automated deployment through GitOps
* Continuous reconciliation of cluster state
* Self-healing and drift detection
* Declarative application management
* End-to-end Git-to-Kubernetes workflow

### Multi-Environment GitOps Deployment

![Multi-Environment GitOps](docs/screenshots/05-multi-environment-gitops/multi-environment-applications.png)

*ArgoCD managing development, staging, and production environments through GitOps. Frontend, API, Authentication, and Database services are deployed across isolated namespaces and continuously synchronized from Git repositories. This demonstrates environment segregation, automated deployment reconciliation, and production-style application lifecycle management using GitOps principles.*

## Prometheus Metrics Collection

### Prometheus Target Discovery & Health Verification

![Prometheus Targets](docs/screenshots/04-prometheus/prometheus-targets.png)

Prometheus successfully discovers and scrapes metrics from Kubernetes workloads through ServiceMonitor resources provided by the Prometheus Operator. The target health dashboard confirms successful metric collection from Grafana, Alertmanager, Prometheus components, and Kubernetes services, providing a reliable foundation for monitoring and alerting.

**Key Highlights**
- Automated target discovery using ServiceMonitors
- Continuous metrics collection from Kubernetes services
- Health verification of monitoring endpoints
- Production-grade monitoring foundation for platform operations

---

## Grafana Cluster Dashboard

### Kubernetes Resource Monitoring

![Grafana Dashboard](docs/screenshots/05-grafana/kubernetes-cluster-dashboard.png)

Grafana provides real-time visibility into cluster health, resource utilization, and workload performance across all environments. Metrics collected by Prometheus are visualized through dashboards that track CPU consumption, memory utilization, workload capacity, and namespace-level resource allocation.

**Monitored Environments**
- Dev
- Stage
- Production

**Observed Metrics**
- CPU Utilization
- CPU Requests & Limits
- Memory Utilization
- Memory Requests & Limits
- Namespace Resource Consumption
- Workload Health & Capacity

---

## Monitoring Architecture

```text
Applications
     │
     ▼
Prometheus Operator
     │
     ▼
Prometheus
     │
     ▼
Grafana
     │
     ▼
Dashboards & Alerts
```

The observability stack enables centralized monitoring, performance analysis, troubleshooting, and operational visibility across the GitOps-managed Kubernetes platform.