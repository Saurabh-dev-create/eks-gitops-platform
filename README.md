# Enterprise Platform Engineering

Production-grade Platform Engineering stack implementing GitOps, observability, security policies, progressive delivery, and incident-ready operations on Kubernetes.
# Automation Scripts

| Script | Purpose |
|---------|---------|
| cleanup.sh | Deletes the existing Kind cluster |
| create-kind-cluster.sh | Creates a 3-node Kind cluster |
| install-argocd.sh | Installs ArgoCD |
| install-monitoring.sh | Installs Prometheus, Grafana, Loki, Alloy, Tempo and OpenTelemetry |
| install-security.sh | Installs Kyverno and applies security policies |
| bootstrap.sh | Builds the complete platform from scratch |

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

![Kyverno Components](docs/screenshots/08-kyverno/kyverno-components.png)

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

### Policy Enforcement: Resource Governance

![Resource Policy Violation](docs/screenshots/08-kyverno/resource-policy-violation.png)

*Kyverno enforced platform governance by blocking deployment of a non-compliant workload that did not define CPU and memory requests/limits. This prevents uncontrolled resource consumption and ensures workloads adhere to operational standards before reaching the cluster.*

### Policy Enforcement: Non-Root Containers

![Non-Root Policy Violation](docs/screenshots/08-kyverno/non-root-policy-violation.png)

*Kyverno enforced the cluster security policy by rejecting a Pod that did not specify `runAsNonRoot: true`. Running containers as non-root reduces the risk of privilege escalation and follows Kubernetes security best practices by preventing workloads from executing with root privileges.*

### Policy Enforcement: Disallow Latest Image Tag

![Latest Tag Policy Violation](docs/screenshots/08-kyverno/latest-tag-policy-violation.png)

*Kyverno enforced deployment governance by rejecting a Pod that used the mutable `latest` image tag. Requiring explicit image versions ensures reproducible deployments, supports controlled application releases, and prevents unexpected behavior caused by automatic image updates.*

### Policy Enforcement: Required Labels

![Required Labels Policy Violation](docs/screenshots/08-kyverno/required-labels-policy-violation.png)

*Kyverno enforced organizational governance by rejecting a Pod that did not define the required `app` and `environment` labels. Standardized labels improve workload identification, enable reliable service discovery, support monitoring and GitOps workflows, and simplify operational management across Kubernetes environments.*

### Policy Enforcement: Require Liveness Probe

![Liveness Probe Policy Violation](docs/screenshots/08-kyverno/liveness-probe-policy-violation.png)

*Kyverno enforced workload health standards by rejecting a Pod that did not define a `livenessProbe`. Requiring liveness probes enables Kubernetes to detect unhealthy containers and automatically restart them, improving application reliability and reducing manual intervention.*

### Policy Enforcement: Require Readiness Probe

![Readiness Probe Policy Violation](docs/screenshots/08-kyverno/kyverno-readiness-policy.png)

*Kyverno enforced workload readiness standards by rejecting a Pod that did not define a `readinessProbe`. Requiring readiness probes ensures that traffic is routed only to containers that are fully initialized and ready to serve requests, improving application availability and preventing requests from reaching unhealthy or unprepared workloads.*

## Progressive Delivery with Argo Rollouts Overview

To enable production-grade deployment strategies, this platform integrates Argo Rollouts for progressive delivery on Kubernetes.

Argo Rollouts extends the native Deployment resource and enables:

Blue-Green Deployments
Canary Deployments
Automated Rollbacks
Controlled Promotions
Safer Application Releases

This allows application updates to be validated before exposing them to production traffic, reducing deployment risk and minimizing downtime.

Blue-Green Deployment

A Blue-Green deployment strategy was implemented using Argo Rollouts.

Workflow
Existing application version serves production traffic.
New version is deployed to a preview environment.
Validation and testing are performed on the preview version.
Traffic is promoted to the new version after approval.
Previous version remains available for rollback if required.
Rollout Configuration
Active Service: frontend-active
Preview Service: frontend-preview
Replicas: 2
Auto Promotion: Disabled
Manual Promotion Enabled
Benefits
Zero downtime deployments
Instant rollback capability
Safe production releases
Reduced deployment risk
Deployment Verification

The rollout controller successfully created and managed a dedicated ReplicaSet for the new application version.

Verification Commands
kubectl get rollout

kubectl get rs

kubectl get pods

kubectl argo rollouts get rollout frontend-rollout
Example Output
NAME               DESIRED
frontend-rollout   2

ReplicaSet
frontend-rollout-7cb98c7

Pods
frontend-rollout-7cb98c7-5hlfl
frontend-rollout-7cb98c7-98jxr
Blue-Green Deployment Validation

The following screenshot demonstrates a successful Blue-Green deployment managed by Argo Rollouts.

![blue-green-delivery](docs/screenshots/09-blue-green/blue-green-rollout.png.png)
Argo Rollouts Deployment Verification

Argo Rollouts successfully created a new ReplicaSet and managed application pods using a Blue-Green deployment strategy.

### Blue-Green Deployment with Argo Rollouts

![Blue-Green Preview Ready](docs/screenshots/09-blue-green/blue-green-preview-ready.png)

*Argo Rollouts deployed a new application version (nginx:1.28) to the preview environment while production traffic continued serving the stable version (nginx:1.27). The rollout entered a paused state with manual promotion enabled, demonstrating a production-grade Blue-Green deployment workflow where new releases can be validated before traffic cutover. Separate active and preview services ensure zero-downtime deployments and safe release validation.*

### Blue-Green Promotion Using Argo Rollouts

![Blue-Green Promotion](docs/screenshots/09-blue-green/blue-green-promotion.png)

*Installed the Argo Rollouts CLI plugin and manually promoted a pending Blue-Green deployment. The rollout promotion switched production traffic from the stable ReplicaSet to the validated preview ReplicaSet, demonstrating controlled release management and zero-downtime deployment practices.*

### Blue-Green Deployment Promotion

![Blue-Green Promotion Complete](docs/screenshots/09-blue-green/blue-green-promotion-complete.png)

*Argo Rollouts successfully promoted the validated application version from the preview environment to production. Traffic was switched from the stable ReplicaSet to the new ReplicaSet, and the previous version was automatically scaled down. This demonstrates a production-grade Blue-Green deployment strategy with controlled approval, zero downtime, and safe release management.*

### Canary Deployment Initialization

![Canary Deployment](docs/screenshots/10-canary/canary-initial-deployment.png)

*Argo Rollouts deployed a canary-enabled frontend application with four replicas. The rollout controller manages progressive traffic shifting and staged promotion of new versions, enabling safer production releases compared to standard Kubernetes rolling updates.*

## Canary Deployment with Argo Rollouts

Argo Rollouts was implemented to enable progressive delivery and reduce deployment risk.

The rollout strategy gradually shifted traffic to a new application version before promoting it to production.

### Canary Rollout Result

![Canary Rollout](docs/screenshots/10-canary/canary-rollout-success.png)

Key capabilities demonstrated:

- Progressive traffic shifting
- Controlled release promotion
- Automatic ReplicaSet management
- Safe production deployments
- Rollback-ready deployment strategy

The rollout successfully promoted nginx:1.28 to stable after completing all canary stages and automatically scaled down the previous ReplicaSet.

## Runtime Security with Falco

Falco was deployed as a DaemonSet across all Kubernetes nodes to provide runtime threat detection.

During deployment, Kyverno blocked the Falco installation because required CPU and memory requests/limits were missing. The Helm chart values were updated to comply with cluster governance policies before the deployment was approved.

### Falco Deployment

![Falco Deployment](docs/screenshots/14-security/falco-successful-deployment.png)

Capabilities:

- Runtime security monitoring
- Kubernetes audit event monitoring
- Container activity detection
- Policy-driven deployment enforcement through Kyverno
- Cluster-wide security visibility

## Runtime Security with Falco

Falco was deployed as a DaemonSet across all Kubernetes nodes to provide runtime threat detection.

A test workload was created and a sensitive file access operation was executed inside the container.

### Runtime Threat Detection

![Falco Runtime Detection](docs/screenshots/14-security/falco-runtime-detection.png)

### Sensitive File Access Simulation

![Falco Shadow Access](docs/screenshots/14-security/falco-shadow-file-access.png)

Falco successfully detected:

- Interactive shell execution inside containers
- Access to sensitive system files
- Suspicious runtime activity

This demonstrates runtime security monitoring beyond static image scanning and policy enforcement.

## 🚨 Incident Detection & Alerting

The platform continuously monitors Kubernetes workloads using Prometheus. When a pod enters a `CrashLoopBackOff` state, a custom alert rule is triggered and Alertmanager automatically sends a Slack notification to the operations team.

### Features

- Real-time CrashLoopBackOff detection
- Custom Prometheus alert rules
- Alertmanager integration
- Slack notifications with runbook links
- Automatic resolved notifications

### Workflow

```text
Kubernetes → Prometheus → Alertmanager → Slack
```

### Demo

| Prometheus Alert | Slack Notification |
|------------------|--------------------|
| ![](docs/screenshots/14-security/prometheus-alert-firing.png) | ![](docs/screenshots/14-security/slack-notification.png) |
