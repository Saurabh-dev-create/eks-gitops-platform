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

## Centralized Logging with Loki & Promtail

The platform implements centralized log aggregation using Grafana Loki and Promtail.

### Architecture

Application Pods
        ↓
Container Logs
        ↓
Promtail DaemonSet
        ↓
Loki
        ↓
Grafana Explore

### Features

- Cluster-wide log collection
- Kubernetes metadata enrichment
- Namespace-based filtering
- Application-level log search
- Centralized troubleshooting

### Example Investigation

Frontend application logs can be queried directly from Grafana Explore using Kubernetes labels.

Example query:

{namespace="dev", app="frontend"}

This allows operators to isolate logs for a specific application without accessing individual pods.

### Screenshot

![Frontend Logs in Grafana Explore](docs/screenshots/05-grafana/application-log-search.png)

### Distributed Tracing with Tempo

OpenTelemetry Collector receives OTLP traces and forwards them to Tempo.
Grafana provides end-to-end trace visualization, span hierarchy analysis,
and latency investigation capabilities.

![Tempo Trace Analysis](docs/screenshots/07-tempo/tempo-trace-details.png)

## Security & Governance with Kyverno

### Kyverno Deployment

![Kyverno Components](docs/screenshots/09-kyverno/kyverno-components-running.png)

*Kyverno deployed as the Kubernetes policy engine, providing admission control, policy enforcement, compliance reporting, and governance capabilities across development, staging, and production environments.*

### Platform Governance Architecture

```text
Developer
    │
    ▼
Git Commit
    │
    ▼
ArgoCD
    │
    ▼
Kubernetes API Server
    │
    ▼
Kyverno Admission Controller
    │
    ├── Validate Policies
    ├── Enforce Security Rules
    ├── Generate Reports
    └── Audit Existing Resources
    │
    ▼
Cluster Resources
```

### Governance Capabilities

- Enforce organization-wide Kubernetes policies
- Prevent deployment of non-compliant workloads
- Validate resource requests and limits
- Enforce application labeling standards
- Restrict insecure container configurations
- Generate compliance and policy reports
- Apply governance consistently across Dev, Stage, and Prod environments

### Installed Components

| Component | Purpose |
|------------|----------|
| Admission Controller | Intercepts and validates Kubernetes resources |
| Background Controller | Continuously evaluates existing resources |
| Reports Controller | Generates policy compliance reports |
| Cleanup Controller | Handles automated resource cleanup tasks |
