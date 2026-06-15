# Project 16 - Deploy Applications to Amazon EKS Using ArgoCD (GitOps)

## Problem Statement

Your company has an Amazon EKS cluster (from Project 15) but deploys applications manually.

Current Problems:

- Developers run `kubectl apply` manually — no audit trail
- Configuration drift between Git and live cluster
- No automated rollback when deployments fail
- Multiple teams deploying to the same cluster inconsistently

Build a production GitOps workflow using ArgoCD on Amazon EKS — Git is the single source of truth, and every cluster change is tracked, auditable, and reversible.

---

## Architecture

```
Developer
    │
    ▼ git push
GitHub Repository
(deployment.yaml, service.yaml)
    │
    ▼ ArgoCD polls / webhook
ArgoCD
(running in argocd namespace on EKS)
    │
    ├── Compares: Git state vs Live EKS state
    ├── Auto-syncs on commit (or manual sync)
    └── Self-heals on drift
          │
          ▼
Amazon EKS Cluster
└── Namespace: eks-argocd-demo
      ├── Deployment: nginx (2 replicas, nginx:1.27)
      └── Service: nginx-service (LoadBalancer → AWS ALB/NLB)
```

---

## Project Structure

```
16-eks-argocd-gitops/
├── deployment.yaml    ← Nginx Deployment (namespace, pinned image, resources, probes)
└── service.yaml       ← Nginx Service (LoadBalancer type — gets real AWS ELB)
```

---

## Prerequisites

- Amazon EKS cluster running (from Project 15 or existing cluster)
- kubectl configured for EKS: `aws eks update-kubeconfig --region ap-south-1 --name devops-cluster`
- GitHub account to host the manifests repository

Verify cluster access:

```bash
kubectl get nodes
```

Expected:

```
NAME                                       STATUS   ROLES    AGE
ip-10-0-3-xx.ap-south-1.compute.internal  Ready    <none>   10m
ip-10-0-4-xx.ap-south-1.compute.internal  Ready    <none>   10m
```

---

## Step 1 - Push Manifests to GitHub

Create a new GitHub repository (e.g., `eks-argocd-manifests`) and push:

```bash
git init
git add deployment.yaml service.yaml
git commit -m "Initial EKS GitOps manifests"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/eks-argocd-manifests.git
git push -u origin main
```

---

## Step 2 - Create ArgoCD Namespace and Install ArgoCD

```bash
kubectl create namespace argocd

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait for all ArgoCD pods to be ready:

```bash
kubectl get pods -n argocd -w
```

Expected — all `Running` (takes 2–3 minutes):

```
NAME                                                READY   STATUS
argocd-application-controller-0                     1/1     Running
argocd-server-xxxxxxxxx-xxxxx                       1/1     Running
argocd-repo-server-xxxxxxxxx-xxxxx                  1/1     Running
argocd-dex-server-xxxxxxxxx-xxxxx                   1/1     Running
argocd-redis-xxxxxxxxx-xxxxx                        1/1     Running
```

---

## Step 3 - Get ArgoCD Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Save this password.

---

## Step 4 - Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open: `https://localhost:8080`

Login: username `admin`, password from Step 3.

> ℹ️ For production, expose ArgoCD via an Ingress with TLS instead of port-forward.

---

## Step 5 - Create the Application Namespace

```bash
kubectl create namespace eks-argocd-demo
```

---

## Step 6 - Create ArgoCD Application

In the ArgoCD UI, click **+ New App**:

| Field | Value |
|-------|-------|
| Application Name | `nginx-app` |
| Project | `default` |
| Sync Policy | `Automatic` |
| Repository URL | `https://github.com/YOUR_USERNAME/eks-argocd-manifests` |
| Revision | `HEAD` |
| Path | `.` |
| Cluster URL | `https://kubernetes.default.svc` |
| Namespace | `eks-argocd-demo` |

Click **Create**.

---

## Step 7 - Verify Sync and Health

In ArgoCD UI — application should show:

```
✅ Healthy
✅ Synced
```

Verify in kubectl:

```bash
kubectl get all -n eks-argocd-demo
```

Expected:

```
NAME                         READY   STATUS    RESTARTS
pod/nginx-xxxxxxxxx-xxxxx    1/1     Running   0
pod/nginx-xxxxxxxxx-yyyyy    1/1     Running   0

NAME                TYPE           EXTERNAL-IP
nginx-service       LoadBalancer   abc123.ap-south-1.elb.amazonaws.com
```

> ℹ️ On EKS, a `LoadBalancer` service provisions a real AWS Classic Load Balancer or NLB automatically — this is the key difference from Minikube (Project 13).

---

## Step 8 - Access the Application

```bash
kubectl get svc nginx-service -n eks-argocd-demo
```

Copy the `EXTERNAL-IP` and open it in your browser:

```
http://abc123.ap-south-1.elb.amazonaws.com
```

Expected — Nginx welcome page.

---

## Step 9 - Test GitOps — Scale via Git

Edit `deployment.yaml` locally — change replicas to 5:

```yaml
spec:
  replicas: 5
```

Commit and push:

```bash
git add deployment.yaml
git commit -m "Scale nginx to 5 replicas"
git push origin main
```

ArgoCD detects the change and applies it automatically. Watch:

```bash
kubectl get pods -n eks-argocd-demo -w
```

Expected — 5 pods running within seconds.

---

## Step 10 - Test Drift Detection

Manually scale down (simulates someone bypassing GitOps):

```bash
kubectl scale deployment nginx -n eks-argocd-demo --replicas=1
```

Within 3 minutes, ArgoCD detects the drift and restores to 5 replicas.

---

## Verification Checklist

✅ EKS cluster nodes `Ready`

✅ ArgoCD installed — all pods `Running` in `argocd` namespace

✅ GitHub repo connected as ArgoCD source

✅ Application `Healthy` + `Synced` in ArgoCD UI

✅ Pods running in `eks-argocd-demo` namespace

✅ AWS Load Balancer EXTERNAL-IP accessible

✅ Git replica change auto-applied by ArgoCD

✅ Drift (kubectl scale) auto-corrected by ArgoCD

---

## Cleanup

```bash
# Remove test workload namespace
kubectl delete namespace eks-argocd-demo

# Remove ArgoCD
kubectl delete namespace argocd

# Destroy EKS cluster (if no longer needed — see Project 15)
cd ../15-terraform-eks && terraform destroy
```

---

## Production Notes

> **1. Use AWS Load Balancer Controller Instead of Classic ELB**
> Install the AWS Load Balancer Controller to get Application Load Balancers (ALB) with path-based routing and HTTPS instead of Classic Load Balancers.

> **2. Expose ArgoCD via Ingress (Not Port-Forward)**
> In production, create an Ingress for ArgoCD with TLS using cert-manager and a real domain.

> **3. Configure GitHub Webhook for Instant Sync**
> ArgoCD polls Git every 3 minutes. Add a webhook for near-instant deployment on push.

> **4. Use ArgoCD ApplicationSets for Multi-Environment**
> Deploy the same application to dev/staging/prod using ArgoCD ApplicationSets with environment-specific values.

---

## Key Learnings

- GitOps on Amazon EKS (production cloud environment)
- ArgoCD installation and configuration on EKS
- `LoadBalancer` service on EKS → AWS ELB/NLB provisioning
- ArgoCD Application creation (repo, path, namespace, auto-sync)
- Drift detection and self-healing on production cluster
- Kubernetes subnet tags required for AWS Load Balancer
- AWS Load Balancer Controller (ALB — production upgrade)
- ArgoCD Ingress exposure with TLS (production pattern)
- GitHub webhook for instant ArgoCD sync
- ArgoCD ApplicationSets for multi-environment deployments
