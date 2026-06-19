# Readiness Probe Failure Runbook

## Overview

A readiness probe determines whether a container is ready to receive traffic.

When the probe fails:

* Pod remains running
* Pod is removed from Service endpoints
* Traffic is not routed to the Pod

---

## Symptoms

```bash
kubectl get pods
```

Example:

```text
NAME        READY
nginx-pod   0/1
```

---

## Investigation

### Check Pod Events

```bash
kubectl describe pod <pod-name>
```

Look for:

```text
Readiness probe failed
```

---

### Validate Endpoint

```bash
kubectl exec -it <pod-name> -- sh
```

Example:

```bash
curl localhost
```

or

```bash
curl localhost/health
```

---

### Verify Probe Configuration

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 80
```

Ensure endpoint exists.

---

## Common Root Causes

| Cause              | Description                         |
| ------------------ | ----------------------------------- |
| Wrong path         | Endpoint does not exist             |
| Wrong port         | Probe points to incorrect port      |
| Slow startup       | Application needs more startup time |
| Dependency failure | Database or API unavailable         |

---

## Resolution

Correct readiness probe:

```yaml
readinessProbe:
  httpGet:
    path: /
    port: 80
```

Apply changes:

```bash
kubectl apply -f deployment.yaml
```

---

## Verification

```bash
kubectl get pods
```

Expected:

```text
READY
1/1
```

Check endpoints:

```bash
kubectl get endpoints
```

Pod should appear in endpoint list.

---

## Lessons Learned

* Test health endpoints before deployment
* Use startup probes for slow applications
* Monitor readiness failures with Prometheus alerts
* Validate application dependencies
