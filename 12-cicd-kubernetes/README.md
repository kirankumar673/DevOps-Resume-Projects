# Project 12 - CI/CD Pipeline for Kubernetes Using GitHub Actions

## Problem Statement

Your company deploys a Kubernetes application manually on every release.

Current Problems:

- Developers run `kubectl apply` manually — inconsistent and error-prone
- No automated image building or versioning
- `latest` image tag used — no traceability of what's deployed
- Deployment failures cause downtime with no rollback mechanism

Build a CI/CD pipeline using GitHub Actions that automatically builds, pushes, and deploys to Kubernetes on every push to main.

---

## Architecture

```
Developer pushes code
        │
        ▼
GitHub Repository
        │
        ▼ GitHub Actions triggers
        │
        ├── Job 1: build  (push + PR)
        │     ├── Checkout code
        │     ├── Tag image with git SHA (not "latest")
        │     ├── Build Docker image
        │     └── Push to DockerHub
        │           │
        │           ▼ (must pass)
        └── Job 2: deploy  (main branch only)
              ├── Configure kubectl (from KUBECONFIG secret)
              ├── Create namespace (idempotent)
              ├── kubectl apply deployment + service
              ├── kubectl set image (SHA-tagged)
              └── kubectl rollout status (wait + verify)

Kubernetes Cluster
└── Namespace: cicd-demo
      ├── Deployment: python-app (2 replicas)
      └── Service: python-app-service (NodePort)
```

---

## Project Structure

```
12-cicd-kubernetes/
├── .github/
│   └── workflows/
│       └── deploy.yml        ← Full CI/CD pipeline (build + deploy jobs)
├── Dockerfile                ← Production-grade (gunicorn, non-root, HEALTHCHECK)
├── deployment.yaml           ← K8s Deployment (namespace, resources, probes)
├── service.yaml              ← K8s Service (NodePort, namespace)
└── source-code/
    ├── app.py                ← Flask app with /health endpoint
    └── requirements.txt      ← Pinned dependencies (flask, gunicorn)
```

---

## Prerequisites

- GitHub Account
- DockerHub Account → [Sign up free](https://hub.docker.com/)
- Kubernetes cluster with `kubectl` access (Minikube for local, or EKS/GKE for cloud)
- Docker installed → [Install Docker](https://docs.docker.com/get-docker/)

---

## Step 1 - Fork / Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/github-actions-k8s-demo.git
cd github-actions-k8s-demo
```

---

## Step 2 - Update deployment.yaml

Replace `YOUR_DOCKERHUB_USERNAME` in `deployment.yaml` with your DockerHub username:

```yaml
image: YOUR_DOCKERHUB_USERNAME/python-app:latest
```

> ℹ️ The CI/CD pipeline will automatically override this tag with the git commit SHA on every deployment.

---

## Step 3 - Add GitHub Secrets

Go to: GitHub Repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

| Secret Name | Value |
|-------------|-------|
| `DOCKER_USERNAME` | Your DockerHub username |
| `DOCKER_PASSWORD` | Your DockerHub password or access token |
| `KUBECONFIG` | Contents of your `~/.kube/config` file (base64 or raw) |

Get your KUBECONFIG contents:

```bash
cat ~/.kube/config
```

Paste the full contents as the `KUBECONFIG` secret value.

> ⚠️ Use a DockerHub **Access Token** (not your password): DockerHub → Account Settings → Security → New Access Token

---

## Step 4 - Review the CI/CD Workflow

The workflow at `.github/workflows/deploy.yml` has two jobs:

**Job 1: `build`** — runs on every push AND pull request:
- Tags image with `${{ github.sha }}` (unique per commit — no more `latest` guessing)
- Builds and pushes both the SHA-tagged and `latest` image to DockerHub

**Job 2: `deploy`** — runs on push to `main` ONLY (after `build` succeeds):
- Sets up `kubectl` with your KUBECONFIG secret
- Creates `cicd-demo` namespace (idempotent — safe to re-run)
- Applies deployment and service manifests
- Updates image to the SHA-tagged version: `kubectl set image`
- Waits for rollout: `kubectl rollout status --timeout=120s`

---

## Step 5 - Push Code to Trigger the Pipeline

```bash
git add .
git commit -m "Initial CI/CD pipeline setup"
git push origin main
```

---

## Step 6 - Monitor the Workflow

1. Go to your GitHub repository
2. Click the **Actions** tab
3. Click the running workflow **Deploy To Kubernetes**

Expected:

```
Deploy To Kubernetes
├── build   ✅  Pushed image: yourusername/python-app:abc1234
└── deploy  ✅  Deployment rolled out successfully
```

---

## Step 7 - Verify the Kubernetes Deployment

```bash
kubectl get pods -n cicd-demo
```

Expected:

```
NAME                          READY   STATUS    RESTARTS
python-app-xxxxxxxxx-xxxxx    1/1     Running   0
python-app-xxxxxxxxx-yyyyy    1/1     Running   0
```

Check the image tag deployed (should be the git SHA, not `latest`):

```bash
kubectl describe pod -n cicd-demo | grep Image:
```

Expected:

```
Image: yourusername/python-app:abc1234def5678
```

---

## Step 8 - Access the Application

```bash
minikube service python-app-service -n cicd-demo --url
```

Open the URL in your browser or:

```bash
curl $(minikube service python-app-service -n cicd-demo --url)
```

Expected:

```
Deployed Using GitHub Actions
```

---

## Step 9 - Test Auto-Deployment (Make a Change)

Edit `source-code/app.py` — change the response message:

```python
return "Deployed Using GitHub Actions - v2"
```

Commit and push:

```bash
git add .
git commit -m "Update response message"
git push origin main
```

Watch the pipeline run automatically in the Actions tab, then refresh your browser — the change deploys without any manual `kubectl` commands.

---

## Verification Checklist

✅ GitHub Secrets configured (DOCKER_USERNAME, DOCKER_PASSWORD, KUBECONFIG)

✅ `build` job passes — image pushed with git SHA tag

✅ `deploy` job passes — `kubectl rollout status` shows success

✅ Pods in `cicd-demo` namespace are `Running`

✅ Image tag on pods is git SHA (not `latest`)

✅ Application accessible via Minikube URL

✅ Code change triggers automatic redeployment end-to-end

---

## Troubleshooting

**`build` job fails — Docker login error:**
- Check `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets are set correctly
- Use a DockerHub Access Token instead of your password

**`deploy` job fails — kubectl authentication error:**
- Verify the `KUBECONFIG` secret contains valid cluster credentials
- For Minikube: note that `localhost` in kubeconfig won't work from GitHub Actions — you need a publicly accessible cluster

**Pods in `ImagePullBackOff`:**
- The image tag in `deployment.yaml` doesn't exist in DockerHub
- Check the DockerHub repo and confirm the SHA-tagged image was pushed

---

## Cleanup

```bash
kubectl delete namespace cicd-demo
```

---

## Production Notes

> **1. Use Git SHA Tags — Never `latest` in Production**
> `latest` makes it impossible to know what code is running in production. Always tag with `${{ github.sha }}` for full traceability and easy rollback.

> **2. Use a Dedicated Service Account for CI/CD**
> Instead of using your personal kubeconfig, create a Kubernetes Service Account with minimal RBAC permissions scoped to the `cicd-demo` namespace only.

> **3. Add Rollback on Failure**
> ```yaml
> - name: Rollback on failure
>   if: failure()
>   run: kubectl rollout undo deployment/python-app -n cicd-demo
> ```

> **4. Use ArgoCD Instead of kubectl in CI/CD**
> For production GitOps, push the image tag update to the Git repo and let ArgoCD handle the deployment (see Project 13).

---

## Key Learnings

- GitHub Actions multi-job pipeline (`build` + `deploy` with `needs`)
- Docker image tagging with git SHA (`${{ github.sha }}`)
- `docker/login-action` for DockerHub authentication
- `kubectl set image` for rolling image updates
- `kubectl rollout status --timeout` for deployment verification
- `kubectl create namespace --dry-run=client -o yaml | kubectl apply -f -` (idempotent namespace creation)
- KUBECONFIG as a GitHub Secret
- `azure/setup-kubectl` action
- Concurrency control (`cancel-in-progress`)
- Kubernetes namespace isolation (`cicd-demo`)
- Resource limits and health probes on Deployments
- Gunicorn + non-root user + HEALTHCHECK in Dockerfile
