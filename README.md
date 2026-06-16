# Enterprise Platform Engineering

Production-grade Platform Engineering stack implementing GitOps, observability, security policies, progressive delivery, and incident-ready operations on Kubernetes.
### Kind Cluster Verification

![Cluster Verification](docs/screenshots/01-kind-cluster/cluster.png)

*Fresh Kubernetes cluster showing only core system components before platform bootstrap, ensuring a clean and reproducible GitOps setup.*

### ArgoCD Bootstrap

![ArgoCD Components](docs/screenshots/02-argocd/argocd-components-running.png)

*Successfully deployed ArgoCD as the GitOps control plane. Verified that all core components—including the API server, application controller, repository server, Redis, Dex, notifications controller, and ApplicationSet controller—are running and healthy.*