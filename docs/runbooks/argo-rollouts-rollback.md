# Argo Rollouts Rollback Runbook

## Overview

Argo Rollouts enables progressive delivery through Blue-Green and Canary deployment strategies.

Rollback procedures are used when a deployment introduces failures after release.

---

## Symptoms

Application degradation after deployment:

* Increased latency
* Error spikes
* Failed health checks
* Customer impact

---

## Investigation

### Check Rollout Status

```bash
kubectl argo rollouts get rollout <rollout-name>
```

Example:

```text
Status: Degraded
```

---

### Review Rollout History

```bash
kubectl argo rollouts history <rollout-name>
```

---

### Inspect ReplicaSets

```bash
kubectl get rs
```

---

### Verify Application Health

```bash
kubectl get pods
kubectl logs <pod-name>
```

---

## Blue-Green Rollback

Promote stable version:

```bash
kubectl argo rollouts undo <rollout-name>
```

---

## Canary Rollback

Rollback to previous revision:

```bash
kubectl argo rollouts undo <rollout-name>
```

---

## Monitor Rollout

```bash
kubectl argo rollouts get rollout <rollout-name> --watch
```

Expected:

```text
Status: Healthy
```

---

## Verification

Confirm:

```bash
kubectl get pods
```

All pods healthy.

Verify application functionality.

---

## Common Root Causes

| Cause                | Description                    |
| -------------------- | ------------------------------ |
| Bad release          | Application defect             |
| Misconfiguration     | Invalid environment variables  |
| Resource exhaustion  | CPU/Memory pressure            |
| Dependency outage    | Database/API unavailable       |
| Failed health checks | Readiness or liveness failures |

---

## Lessons Learned

* Progressive delivery reduces deployment risk.
* Canary analysis should validate application health before promotion.
* Blue-Green deployments provide rapid rollback capability.
* Rollback procedures should be tested regularly.
