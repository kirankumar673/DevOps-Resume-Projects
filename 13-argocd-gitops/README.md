# Project 13 - Deploy Applications Using ArgoCD (GitOps)

## Problem Statement

Your company deploys applications to Kubernetes manually using `kubectl apply`.

Current Problems:

- Manual `kubectl apply` on every release — inconsistent and error-prone
- No deployment history or audit trail
- Configuration drift — live cluster state diverges from what's in Git
- Difficult rollback process — no clear way to go back to a previous state
- No automatic detection of unauthorised changes

Build a GitOps solution using ArgoCD — where Git is the single source of truth and ArgoCD automatically syncs the cluster to match.

---

## Architecture

```
Developer
    │
    ▼ git push
GitHub Repository
(deployment.yaml, service.yaml)
    │
    ▼ ArgoCD polls every 3 minutes (or webhook)
ArgoCD
(running in argocd namespace)
    │
    ├── Compares: Git state vs Live cluster state
    │
    ├── If drift detected → Auto-sync (or manual sync)
    │
    └── Applies changes to:
Kubernetes Cluster
└── Namespace: argocd-demo
      ├── Deployment: nginx (2 replicas, nginx:1.27)
      └── Service: nginx (NodePort)
```

---

## Project Structure

```
13-argocd-gitops/
├── deployment.yaml    ← Nginx Deployment (namespace, pinned image, resources, probes)
└── service.yaml       ← Nginx Service (NodePort, namespace)
```

> ℹ️ ArgoCD itself is installed via `kubectl apply` from the official manifests. No Helm chart or extra config files needed for this project.

---

## Prerequisites

- Minikube installed → [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- kubectl installed → [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- GitHub account (to host the manifests repo)

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

Verify:

```bash
kubectl get nodes
```

Expected:

```
NAME       STATUS   ROLES           AGE
minikube   Ready    control-plane   30s
```

---

## Step 2 - Create the ArgoCD Namespace and Install ArgoCD

```bash
kubectl create namespace argocd
```

Install ArgoCD from the official stable manifest:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait for all ArgoCD pods to be ready (this takes 2-3 minutes):

```bash
kubectl get pods -n argocd -w
```

Expected — all pods `Running`:

```
NAME                                                READY   STATUS
argocd-application-controller-0                     1/1     Running
argocd-dex-server-xxxxxxxxx-xxxxx                   1/1     Running
argocd-redis-xxxxxxxxx-xxxxx                        1/1     Running
argocd-repo-server-xxxxxxxxx-xxxxx                  1/1     Running
argocd-server-xxxxxxxxx-xxxxx                       1/1     Running
```

---

## Step 3 - Get the ArgoCD Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Save this password — you'll need it to log in to the UI.

---

## Step 4 - Expose ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open in browser:

```
https://localhost:8080
```

> ⚠️ Your browser will show a certificate warning — click **Advanced** → **Proceed** (this is expected for local Minikube — the cert is self-signed).

Login with:

| Field | Value |
|-------|-------|
| Username | `admin` |
| Password | (output from Step 3) |

---

## Step 5 - Push Manifests to GitHub

Create a new GitHub repository (e.g., `argocd-demo-manifests`) and push the manifest files:

```bash
git init
git add deployment.yaml service.yaml
git commit -m "Initial ArgoCD manifests"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/argocd-demo-manifests.git
git push -u origin main
```

> ℹ️ ArgoCD will watch this repository and sync the cluster to match whatever is in it.

---

## Step 6 - Create the Application Namespace

```bash
kubectl create namespace argocd-demo
```

---

## Step 7 - Create an ArgoCD Application via the UI

1. In the ArgoCD UI, click **+ New App**
2. Fill in the form:

| Field | Value |
|-------|-------|
| Application Name | `nginx-app` |
| Project | `default` |
| Sync Policy | `Automatic` (enables auto-sync) |
| Repository URL | `https://github.com/YOUR_USERNAME/argocd-demo-manifests` |
| Revision | `HEAD` |
| Path | `.` (root of the repo) |
| Cluster URL | `https://kubernetes.default.svc` |
| Namespace | `argocd-demo` |

3. Click **Create**

---

## Step 8 - Sync the Application

If Sync Policy is set to **Automatic**, ArgoCD will sync within seconds.

If Manual, click **SYNC** → **Synchronize**.

Expected status in the UI:

```
✅ Healthy
✅ Synced
```

---

## Step 9 - Verify Deployment

```bash
kubectl get all -n argocd-demo
```

Expected:

```
NAME                         READY   STATUS    RESTARTS
pod/nginx-xxxxxxxxx-xxxxx    1/1     Running   0
pod/nginx-xxxxxxxxx-yyyyy    1/1     Running   0

NAME            TYPE       PORT(S)
service/nginx   NodePort   80:3xxxx/TCP
```

---

## Step 10 - Test GitOps — Update via Git (Not kubectl)

Scale the deployment to 3 replicas **only by editing Git** — not by running kubectl:

Edit `deployment.yaml`:

```yaml
spec:
  replicas: 3   # Changed from 2
```

Commit and push:

```bash
git add deployment.yaml
git commit -m "Scale nginx to 3 replicas"
git push origin main
```

Watch ArgoCD detect and apply the change automatically:

```bash
kubectl get pods -n argocd-demo -w
```

Expected — a third pod appears within seconds:

```
NAME                         READY   STATUS
nginx-xxxxxxxxx-xxxxx        1/1     Running
nginx-xxxxxxxxx-yyyyy        1/1     Running
nginx-xxxxxxxxx-zzzzz        1/1     Running   ← new pod
```

> ℹ️ This is the core of GitOps — Git is the source of truth. You never run `kubectl scale` or `kubectl apply` manually.

---

## Step 11 - Test Drift Detection

Manually change something in the cluster without updating Git (simulates configuration drift):

```bash
kubectl scale deployment nginx -n argocd-demo --replicas=1
```

Watch the ArgoCD UI — within 3 minutes it detects the drift and restores the deployment back to 3 replicas automatically.

This demonstrates **self-healing** — a key GitOps principle.

---

## Verification Checklist

✅ ArgoCD installed — all pods in `argocd` namespace `Running`

✅ ArgoCD UI accessible at `https://localhost:8080`

✅ GitHub repository connected as ArgoCD source

✅ Application shows `Healthy` and `Synced` in ArgoCD UI

✅ Pods running in `argocd-demo` namespace

✅ Git change (replica count) automatically applied to cluster

✅ Manual drift (kubectl scale) automatically corrected by ArgoCD

---

## Troubleshooting

**ArgoCD app shows `OutOfSync`:**
- Click **SYNC** → **Synchronize** in the UI
- Check the sync error message for YAML parsing issues

**ArgoCD can't reach GitHub repo:**
- Ensure the repo is public, or add GitHub credentials in ArgoCD → Settings → Repositories

**Pods in `argocd-demo` not starting:**
```bash
kubectl describe pod -n argocd-demo
kubectl logs -n argocd-demo <POD_NAME>
```

---

## Cleanup

```bash
# Delete the application namespace
kubectl delete namespace argocd-demo

# Delete ArgoCD
kubectl delete namespace argocd

# Stop Minikube
minikube stop
```

---

## Production Notes

> **1. Enable Webhook for Instant Sync**
> By default ArgoCD polls Git every 3 minutes. Configure a GitHub webhook to trigger instant sync on push:
> GitHub Repo → Settings → Webhooks → Add webhook → `https://your-argocd-server/api/webhook`

> **2. Use App of Apps Pattern**
> For managing many applications, use the "App of Apps" pattern — one ArgoCD Application manages a directory of other Application manifests.

> **3. Use ArgoCD Image Updater**
> Automatically update image tags in Git when a new Docker image is pushed to the registry — fully automating the GitOps flow from CI (build) to CD (deploy).

> **4. RBAC and SSO**
> In production, configure ArgoCD RBAC policies and integrate with your identity provider (Okta, GitHub SSO) instead of the `admin` password.

---

## Key Learnings

- GitOps principles (Git as single source of truth)
- ArgoCD installation from official manifests
- ArgoCD Application creation (repo, path, namespace, sync policy)
- Automatic sync vs manual sync
- Drift detection and self-healing (ArgoCD restores cluster to Git state)
- GitHub webhook for instant sync (production pattern)
- `kubectl port-forward` for accessing ArgoCD UI
- ArgoCD admin secret decoding (`base64 -d`)
- App of Apps pattern (managing multiple apps)
- ArgoCD Image Updater (automated image tag updates)
- RBAC + SSO integration (production security)
