# Project 06 - Deploy a Python Application on Kubernetes

## Problem Statement

Your company has containerized a Python application using Docker.

Current Problems:

- Application runs on a single container — no redundancy
- If the container crashes, the app goes down (no auto-healing)
- Cannot scale under load
- No production-grade health monitoring

Build a solution using Kubernetes to get auto-healing, scaling, and production management.

---

## Architecture

```
User
  │
  ▼ Port 80
Kubernetes Service (NodePort)
  │  Load balances across pods
  ├──────────────────────┐
  ▼                      ▼
Pod 1                  Pod 2
(python-app:v1)        (python-app:v1)
Flask + Gunicorn       Flask + Gunicorn
Port 5000              Port 5000

All resources in namespace: python-app
```

---

## Project Structure

```
06-kubernetes-python-app/
├── Dockerfile
├── namespace.yaml
├── deployment.yaml
├── service.yaml
└── source-code/
    ├── app.py
    └── requirements.txt
```

---

## Prerequisites

- Docker installed → [Install Docker](https://docs.docker.com/get-docker/)
- Minikube installed → [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- kubectl installed → [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

Verify all tools:

```bash
docker --version
minikube version
kubectl version --client
```

---

## Step 1 - Start Minikube Cluster

```bash
minikube start
```

Verify the node is ready:

```bash
kubectl get nodes
```

Expected:

```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   30s   v1.xx.x
```

---

## Step 2 - Build Docker Image Inside Minikube

> ⚠️ Minikube has its own Docker daemon. You must build the image **inside Minikube's Docker**, otherwise Kubernetes won't find it.

Point your shell to Minikube's Docker:

```bash
eval $(minikube docker-env)
```

Now build the image:

```bash
docker build -t python-app:v1 .
```

Verify the image exists inside Minikube:

```bash
docker images | grep python-app
```

Expected:

```
python-app   v1   abc123   10 seconds ago   150MB
```

> ℹ️ `imagePullPolicy: Never` in `deployment.yaml` tells Kubernetes to use the local image and not try to pull from DockerHub.

---

## Step 3 - Create the Namespace

Always isolate your workloads in a dedicated namespace — never use `default` in production.

```bash
kubectl apply -f namespace.yaml
```

Verify:

```bash
kubectl get namespaces
```

Expected:

```
NAME          STATUS   AGE
python-app    Active   5s
```

---

## Step 4 - Deploy the Application

```bash
kubectl apply -f deployment.yaml
```

Watch pods come up:

```bash
kubectl get pods -n python-app -w
```

Expected (wait until both are `Running`):

```
NAME                          READY   STATUS    RESTARTS   AGE
python-app-5d8f9c7b4-abc12    1/1     Running   0          20s
python-app-5d8f9c7b4-def34    1/1     Running   0          20s
```

> ℹ️ The Deployment creates 2 replicas. If one pod crashes, Kubernetes automatically restarts it (auto-healing).

---

## Step 5 - Create the Service

```bash
kubectl apply -f service.yaml
```

Verify:

```bash
kubectl get svc -n python-app
```

Expected:

```
NAME                 TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
python-app-service   NodePort   10.96.xx.xx    <none>        80:3xxxx/TCP   5s
```

---

## Step 6 - Access the Application

Get the URL from Minikube:

```bash
minikube service python-app-service -n python-app --url
```

Expected output:

```
http://192.168.49.2:3xxxx
```

Open that URL in your browser or test with curl:

```bash
curl $(minikube service python-app-service -n python-app --url)
```

Expected:

```
Hello From Kubernetes
```

Test the health endpoint:

```bash
curl $(minikube service python-app-service -n python-app --url)/health
```

Expected:

```json
{"status": "healthy"}
```

---

## Step 7 - Verify Health Probes

Check that Kubernetes has validated the liveness and readiness probes:

```bash
kubectl describe pod -n python-app
```

Look for in the output:

```
Liveness:   http-get http://:5000/health  ...
Readiness:  http-get http://:5000/health  ...
```

---

## Step 8 - Scale the Application

Scale up to 5 replicas:

```bash
kubectl scale deployment python-app -n python-app --replicas=5
```

Watch pods scale up:

```bash
kubectl get pods -n python-app -w
```

Expected — 5 pods all `Running`:

```
NAME                          READY   STATUS    RESTARTS
python-app-5d8f9c7b4-abc12    1/1     Running   0
python-app-5d8f9c7b4-def34    1/1     Running   0
python-app-5d8f9c7b4-ghi56    1/1     Running   0
python-app-5d8f9c7b4-jkl78    1/1     Running   0
python-app-5d8f9c7b4-mno90    1/1     Running   0
```

Scale back down:

```bash
kubectl scale deployment python-app -n python-app --replicas=2
```

---

## Step 9 - Test Auto-Healing

Delete a pod manually to simulate a crash:

```bash
kubectl delete pod <POD_NAME> -n python-app
```

Immediately watch pods:

```bash
kubectl get pods -n python-app -w
```

Expected — Kubernetes immediately creates a replacement pod:

```
NAME                          READY   STATUS        RESTARTS
python-app-5d8f9c7b4-abc12    0/1     Terminating   0
python-app-5d8f9c7b4-xyz99    0/1     Pending       0
python-app-5d8f9c7b4-xyz99    1/1     Running       0
```

---

## Verification Checklist

✅ Minikube cluster running (`kubectl get nodes` shows Ready)

✅ Namespace `python-app` created

✅ Deployment shows 2/2 pods running

✅ Service created with NodePort

✅ Application accessible via Minikube URL

✅ `/health` endpoint returns `{"status": "healthy"}`

✅ Scaling works (up and down)

✅ Auto-healing works (deleted pod replaced automatically)

---

## Cleanup

```bash
kubectl delete namespace python-app
minikube stop
```

> ℹ️ Deleting the namespace removes ALL resources inside it (deployments, services, pods).

---

## Production Notes

> **1. Use a Remote Image Registry**
> `imagePullPolicy: Never` only works with Minikube. For production (EKS, GKE, AKS), push to DockerHub or ECR:
> ```bash
> docker tag python-app:v1 yourdockerhubuser/python-app:v1
> docker push yourdockerhubuser/python-app:v1
> ```
> Then update `image:` in `deployment.yaml` and set `imagePullPolicy: IfNotPresent`.

> **2. Use Horizontal Pod Autoscaler (HPA)**
> Instead of manually scaling, configure HPA to scale based on CPU:
> ```bash
> kubectl autoscale deployment python-app -n python-app --cpu-percent=50 --min=2 --max=10
> ```

> **3. Use Ingress Instead of NodePort**
> NodePort exposes a random high port. Use an Ingress controller (see Project 08) for proper URL routing with a standard port.

---

## Key Learnings

- Kubernetes Namespace isolation
- Deployment and ReplicaSet concepts
- Pod auto-healing
- Horizontal scaling with `kubectl scale`
- Kubernetes Services (NodePort)
- Resource requests and limits (CPU/memory)
- `livenessProbe` and `readinessProbe`
- `imagePullPolicy: Never` for Minikube local dev
- `eval $(minikube docker-env)` to build inside Minikube
