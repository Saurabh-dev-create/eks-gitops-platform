# OOMKilled Runbook

## Overview

OOMKilled occurs when a container exceeds its configured memory limit and is terminated by the Linux kernel.

---

## Symptoms

```bash
kubectl get pods
```

Pod may restart repeatedly.

---

## Investigation

### Check Pod Details

```bash
kubectl describe pod <pod-name>
```

Look for:

```text
Last State:
  Terminated
  Reason: OOMKilled
  Exit Code: 137
```

---

### Check Resource Usage

```bash
kubectl top pod
```

---

### Review Resource Limits

```bash
kubectl get deployment <deployment-name> -o yaml
```

Check:

```yaml
resources:
  requests:
  limits:
```

---

## Common Root Causes

| Cause             | Description                               |
| ----------------- | ----------------------------------------- |
| Memory leak       | Application consuming memory continuously |
| Large requests    | Excessive data processing                 |
| Low memory limits | Limits too restrictive                    |
| Unbounded cache   | Application cache growth                  |

---

## Resolution

Increase memory limits:

```yaml
resources:
  requests:
    memory: 256Mi
  limits:
    memory: 512Mi
```

Apply:

```bash
kubectl apply -f deployment.yaml
```

Restart:

```bash
kubectl rollout restart deployment <deployment-name>
```

---

## Verification

```bash
kubectl describe pod <pod-name>
```

Verify:

```text
Reason: Running
```

No new OOMKilled events should appear.

---

## Lessons Learned

* Set realistic memory limits
* Monitor memory utilization
* Configure Prometheus alerts for memory pressure
* Perform load testing before production rollout
