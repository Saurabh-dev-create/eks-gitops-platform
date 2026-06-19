# Kyverno Policy Violation Runbook

## Overview

Kyverno enforces Kubernetes security and governance policies.

A deployment may fail when a resource violates one or more cluster policies.

---

## Symptoms

Deployment fails:

```bash
kubectl apply -f deployment.yaml
```

Example error:

```text
admission webhook "validate.kyverno.svc-fail" denied the request

validation error:
CPU and memory requests/limits are required
```

---

## Investigation

### Check Policy Reports

```bash
kubectl get policyreport -A
```

---

### List Cluster Policies

```bash
kubectl get clusterpolicy
```

---

### Describe Specific Policy

```bash
kubectl describe clusterpolicy require-resources
```

---

### Review Admission Error

```bash
kubectl apply -f deployment.yaml
```

Read the exact validation failure.

---

## Common Root Causes

| Cause                       | Description                     |
| --------------------------- | ------------------------------- |
| Missing resources           | CPU/Memory requests not defined |
| Missing labels              | Required labels absent          |
| Privileged container        | Policy blocks privileged mode   |
| HostPath usage              | Policy restricts host mounts    |
| Image registry restrictions | Unauthorized registry           |

---

## Resolution

Example resource fix:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 250m
    memory: 256Mi
```

Reapply:

```bash
kubectl apply -f deployment.yaml
```

---

## Verification

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

Expected:

```text
Deployment successfully created
```

---

## Lessons Learned

* Shift policy validation into CI/CD.
* Maintain deployment templates with required fields.
* Review Kyverno policies before onboarding new workloads.

