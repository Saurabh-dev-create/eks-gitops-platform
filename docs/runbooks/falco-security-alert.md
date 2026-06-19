# Falco Security Alert Runbook

## Overview

Falco provides runtime threat detection for Kubernetes workloads.

It detects suspicious activity such as:

* Shell execution in containers
* Access to sensitive files
* Unexpected network activity
* Privilege escalation attempts

---

## Symptoms

Falco generates alerts such as:

```text
A shell was spawned in a container with an attached terminal
```

or

```text
Sensitive file opened for reading by non-trusted program
```

---

## Investigation

### View Falco Events

```bash
kubectl logs -n falco <falco-pod>
```

---

### Identify Affected Workload

Review alert fields:

```text
k8s_pod_name
k8s_ns_name
process
command
user
```

---

### Inspect Pod

```bash
kubectl describe pod <pod-name> -n <namespace>
```

---

### Check Recent Activity

```bash
kubectl logs <pod-name> -n <namespace>
```

---

### Verify User Activity

Review:

```text
kubectl exec
debug sessions
CI/CD jobs
automation tools
```

---

## Common Root Causes

| Cause                    | Description             |
| ------------------------ | ----------------------- |
| Debugging session        | Engineer opened shell   |
| Unauthorized access      | Potential compromise    |
| Secret inspection        | Reading sensitive files |
| Container escape attempt | Suspicious behavior     |
| Malicious workload       | Security incident       |

---

## Resolution

### Legitimate Activity

Document event and close incident.

### Suspicious Activity

Isolate workload:

```bash
kubectl scale deployment <deployment> --replicas=0
```

or

```bash
kubectl delete pod <pod-name>
```

---

### Rotate Credentials

If secrets may be exposed:

* Rotate Kubernetes Secrets
* Rotate API keys
* Rotate service account credentials

---

## Verification

Confirm:

```bash
kubectl logs -n falco <falco-pod>
```

No additional alerts generated.

---

## Lessons Learned

* Falco detects runtime threats not visible to admission controllers.
* Runtime monitoring complements Kyverno policy enforcement.
* Alerting should be integrated with Slack and incident workflows.
