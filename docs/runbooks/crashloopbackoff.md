# CrashLoopBackOff Runbook

## Overview

A CrashLoopBackOff occurs when a container repeatedly starts, crashes, and Kubernetes delays subsequent restart attempts using exponential backoff.

---

## Symptoms

```bash
kubectl get pods
```

Example:

```text
NAME           READY   STATUS             RESTARTS
api-pod        0/1     CrashLoopBackOff   12
```

---

## Investigation Steps

### Check Pod Details

```bash
kubectl describe pod <pod-name>
```

Look for:

```text
State:          Waiting
Reason:         CrashLoopBackOff
```

---

### Check Container Logs

```bash
kubectl logs <pod-name>
```

If the container restarts too quickly:

```bash
kubectl logs <pod-name> --previous
```

---

### Verify Environment Variables

```bash
kubectl describe pod <pod-name>
```

Check:

* Missing Secrets
* Missing ConfigMaps
* Incorrect environment variables

---

### Verify Image

```bash
kubectl describe pod <pod-name>
```

Check:

```text
Image:
Image ID:
```

---

## Common Root Causes

| Cause                 | Description                 |
| --------------------- | --------------------------- |
| Application crash     | Bug in application code     |
| Missing configuration | Missing ConfigMap or Secret |
| Database unavailable  | Startup dependency failure  |
| Invalid image         | Wrong image tag             |
| Port conflict         | Application cannot bind     |

---

## Resolution

1. Inspect logs
2. Fix application or configuration issue
3. Redeploy workload

```bash
kubectl rollout restart deployment <deployment-name>
```

---

## Verification

```bash
kubectl get pods
```

Expected:

```text
READY  STATUS
1/1    Running
```

---

## Lessons Learned

* Add startup probes
* Add readiness probes
* Add alerting for restart spikes
* Validate application configuration before deployment
