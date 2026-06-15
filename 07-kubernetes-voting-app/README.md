# Project 07 - Deploy a Voting Application on Kubernetes

## Problem Statement

Your company wants to deploy a real-world multi-tier voting application.

Requirements:

- Users can cast votes via a web UI
- Votes must be stored persistently
- Results must display in real time
- Application must scale and self-heal
- Credentials must be stored securely (not hardcoded)

Build the solution using Kubernetes with proper namespacing, secrets, and resource management.

---

## Architecture

```
User (Browser)
      │
      ▼ NodePort
  ┌───────────┐
  │  Vote App │  (dockersamples/examplevotingapp_vote)
  └───────────┘
        │ Writes vote to
        ▼
    ┌───────┐
    │ Redis │  (redis:7) — In-memory queue
    └───────┘
        │ Read by
        ▼
    ┌────────┐
    │ Worker │  (examplevotingapp_worker) — Processes votes
    └────────┘
        │ Writes result to
        ▼
  ┌────────────┐
  │ PostgreSQL │  (postgres:15) — Persistent storage
  └────────────┘
        │ Read by
        ▼
  ┌─────────────┐
  │ Result App  │  (examplevotingapp_result)
  └─────────────┘
        │
        ▼ NodePort
   User (Browser)

All resources in namespace: voting-app
```

---

## Project Structure

```
07-kubernetes-voting-app/
├── namespace.yaml
├── postgres-secret.yaml      ← Database credentials (Kubernetes Secret)
├── redis-deployment.yaml
├── redis-service.yaml
├── postgres-deployment.yaml
├── postgres-service.yaml
├── vote-deployment.yaml
├── vote-service.yaml
├── worker-deployment.yaml
├── result-deployment.yaml
└── result-service.yaml
```

---

## Prerequisites

- Minikube installed → [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- kubectl installed → [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

Verify:

```bash
minikube version
kubectl version --client
```

---

## Step 1 - Start Minikube

```bash
minikube start
```

Verify the cluster is ready:

```bash
kubectl get nodes
```

Expected:

```
NAME       STATUS   ROLES           AGE
minikube   Ready    control-plane   30s
```

---

## Step 2 - Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

Verify:

```bash
kubectl get namespaces | grep voting-app
```

Expected:

```
voting-app   Active   5s
```

---

## Step 3 - Create the PostgreSQL Secret

> ⚠️ **Never hardcode database credentials in deployment manifests.** Always use Kubernetes Secrets.

Before applying, open `postgres-secret.yaml` and change the password:

```yaml
stringData:
  POSTGRES_USER: admin
  POSTGRES_PASSWORD: your_strong_password_here   # ← Change this!
  POSTGRES_DB: votes
```

Apply the secret:

```bash
kubectl apply -f postgres-secret.yaml
```

Verify (values will be base64 encoded — this is expected):

```bash
kubectl get secret postgres-secret -n voting-app
```

Expected:

```
NAME              TYPE     DATA   AGE
postgres-secret   Opaque   3      5s
```

---

## Step 4 - Deploy Redis

```bash
kubectl apply -f redis-deployment.yaml
kubectl apply -f redis-service.yaml
```

Verify Redis is running:

```bash
kubectl get pods -n voting-app -l app=redis
```

Expected:

```
NAME                     READY   STATUS    RESTARTS
redis-xxxxxxxxx-xxxxx    1/1     Running   0
```

---

## Step 5 - Deploy PostgreSQL

```bash
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml
```

Verify PostgreSQL is running:

```bash
kubectl get pods -n voting-app -l app=postgres
```

Expected:

```
NAME                        READY   STATUS    RESTARTS
postgres-xxxxxxxxx-xxxxx    1/1     Running   0
```

---

## Step 6 - Deploy the Vote Application

```bash
kubectl apply -f vote-deployment.yaml
kubectl apply -f vote-service.yaml
```

---

## Step 7 - Deploy the Worker

```bash
kubectl apply -f worker-deployment.yaml
```

---

## Step 8 - Deploy the Result Application

```bash
kubectl apply -f result-deployment.yaml
kubectl apply -f result-service.yaml
```

---

## Step 9 - Deploy Everything at Once (Alternative)

Instead of steps 4–8 one by one, you can apply all files at once:

```bash
kubectl apply -f .
```

> ⚠️ Make sure you have already applied `namespace.yaml` and `postgres-secret.yaml` first (Steps 2 & 3), as other resources depend on them.

---

## Step 10 - Verify All Resources Are Running

```bash
kubectl get all -n voting-app
```

Expected — all pods should be `Running`:

```
NAME                          READY   STATUS    RESTARTS
pod/redis-xxx                 1/1     Running   0
pod/postgres-xxx              1/1     Running   0
pod/vote-xxx-1                1/1     Running   0
pod/vote-xxx-2                1/1     Running   0
pod/worker-xxx                1/1     Running   0
pod/result-xxx-1              1/1     Running   0
pod/result-xxx-2              1/1     Running   0
```

---

## Step 11 - Access the Applications

Get the Vote App URL:

```bash
minikube service vote -n voting-app --url
```

Open the URL in your browser. You should see:

```
Cats  vs  Dogs
(vote buttons)
```

Get the Result App URL:

```bash
minikube service result -n voting-app --url
```

Open the URL in your browser. You should see live voting results update as you vote.

---

## Verification Checklist

✅ Namespace `voting-app` created

✅ `postgres-secret` exists in namespace

✅ Redis pod running with liveness probe passing

✅ PostgreSQL pod running with readiness probe passing

✅ Vote app pods running (2 replicas)

✅ Worker pod running

✅ Result app pods running (2 replicas)

✅ Voting via the Vote URL works

✅ Results update in the Result URL

---

## Troubleshooting

**Pod stuck in `Pending`:**
```bash
kubectl describe pod <POD_NAME> -n voting-app
```
Look for events at the bottom — usually resource constraints or image pull errors.

**Pod in `CrashLoopBackOff`:**
```bash
kubectl logs <POD_NAME> -n voting-app
```

**Secret not found error:**
Make sure you applied `postgres-secret.yaml` before `postgres-deployment.yaml`.

---

## Cleanup

```bash
kubectl delete namespace voting-app
```

> ℹ️ This deletes everything in the namespace — all pods, services, deployments, and secrets.

Stop Minikube:

```bash
minikube stop
```

---

## Production Notes

> **1. Add a PersistentVolumeClaim for PostgreSQL**
> The current setup does not have a PVC — PostgreSQL data will be lost if the pod is rescheduled. Add a PVC to `postgres-deployment.yaml` for data persistence in production.

> **2. Use External Secrets Operator**
> For production clusters, use [External Secrets Operator](https://external-secrets.io/) to sync secrets from AWS Secrets Manager or HashiCorp Vault into Kubernetes Secrets automatically.

> **3. Use NetworkPolicy**
> Lock down inter-pod communication with NetworkPolicy rules — only the Worker should be able to talk to both Redis and PostgreSQL.

---

## Key Learnings

- Multi-tier application architecture on Kubernetes
- Kubernetes Namespace isolation
- Kubernetes Secrets (`secretKeyRef`) vs hardcoded credentials
- Deployment, ReplicaSet, Pod concepts
- Service types (ClusterIP vs NodePort)
- Redis as an in-memory message queue
- `livenessProbe` and `readinessProbe`
- Resource requests and limits
- `kubectl get all -n <namespace>` for full namespace overview
- `kubectl describe` and `kubectl logs` for troubleshooting
