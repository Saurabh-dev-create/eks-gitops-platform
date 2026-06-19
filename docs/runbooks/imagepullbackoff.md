# ImagePullBackOff Runbook

## Overview

ImagePullBackOff occurs when Kubernetes cannot download a container image from a container registry.

The kubelet repeatedly attempts to pull the image and applies exponential backoff between retries.

---

## Symptoms

```bash
kubectl get pods
```

Example:

```text
NAME           READY   STATUS             RESTARTS
api-pod        0/1     ImagePullBackOff   0
```

or

```text
ErrImagePull
```

---

## Investigation

### Check Pod Events

```bash
kubectl describe pod <pod-name>
```

Common output:

```text
Failed to pull image
Back-off pulling image
ErrImagePull
ImagePullBackOff
```

---

### Verify Image Name

Check deployment configuration:

```bash
kubectl get deployment <deployment-name> -o yaml
```

Example:

```yaml
image: nginx:latest
```

Verify:

* Repository exists
* Tag exists
* Image spelling is correct

---

### Verify Registry Access

Attempt manual pull:

```bash
docker pull nginx:latest
```

or

```bash
ctr image pull nginx:latest
```

---

### Verify ImagePullSecrets

Check service account:

```bash
kubectl get serviceaccount default -o yaml
```

Check pod:

```bash
kubectl describe pod <pod-name>
```

Look for:

```yaml
imagePullSecrets:
  - name: registry-secret
```

---

### Verify Registry Credentials

```bash
kubectl get secret
```

Inspect:

```bash
kubectl describe secret registry-secret
```

---

## Common Root Causes

| Cause               | Description                     |
| ------------------- | ------------------------------- |
| Wrong image tag     | Tag does not exist              |
| Typo in image name  | Invalid repository              |
| Private registry    | Missing credentials             |
| Expired credentials | Registry authentication failure |
| Registry outage     | Registry unavailable            |
| Network issue       | Node cannot reach registry      |

---

## Resolution

### Fix Incorrect Tag

Example:

```yaml
image: nginx:1.28
```

Apply:

```bash
kubectl apply -f deployment.yaml
```

---

### Create Registry Secret

```bash
kubectl create secret docker-registry registry-secret \
  --docker-server=<registry> \
  --docker-username=<username> \
  --docker-password=<password>
```

Reference secret:

```yaml
imagePullSecrets:
  - name: registry-secret
```

---

### Restart Deployment

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
READY   STATUS
1/1     Running
```

Confirm image:

```bash
kubectl describe pod <pod-name>
```

Verify:

```text
Successfully pulled image
Started container
```

---

## Prevention

* Use immutable image tags
* Validate image names during CI/CD
* Monitor registry availability
* Rotate registry credentials before expiration
* Store credentials in Kubernetes Secrets

---

## Lessons Learned

* Most ImagePullBackOff incidents are caused by incorrect image names or tags.
* Private registries require valid imagePullSecrets.
* CI/CD pipelines should validate images before deployment.
