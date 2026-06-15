# Resume Points — Project 12: CI/CD Pipeline for Kubernetes

---

## Fresher

- Built a two-job CI/CD pipeline using GitHub Actions that automatically builds a Docker image and deploys it to Kubernetes on every push to main.
- Tagged Docker images with the git commit SHA (`${{ github.sha }}`) instead of `latest` for full deployment traceability.
- Used `kubectl set image` to update running deployments with the new image tag and `kubectl rollout status` to verify successful rollout.
- Stored DockerHub credentials and KUBECONFIG as GitHub Secrets — never hardcoded in the workflow.

---

## Experienced DevOps Engineer

- Designed a production-aligned CI/CD pipeline with separated `build` and `deploy` jobs: `build` runs on both pushes and PRs to validate image creation; `deploy` runs on main branch only after `build` succeeds.
- Implemented git SHA image tagging to eliminate `latest` tag ambiguity — enabling full traceability of exactly what code is running in every environment and enabling precise rollbacks.
- Used idempotent namespace creation (`kubectl create namespace --dry-run=client -o yaml | kubectl apply -f -`) to make the pipeline safe to re-run without errors.
- Applied production Kubernetes manifest patterns: namespace isolation, resource requests/limits, `livenessProbe` and `readinessProbe` on the Deployment, and concurrency control in the workflow.
- Documented `kubectl rollout undo` as an automated rollback strategy and ArgoCD as the GitOps alternative for production deployments.

---

## LinkedIn Project Description

Built a production-grade CI/CD pipeline using GitHub Actions for Kubernetes deployments: two-job architecture (`build` + `deploy` with `needs` dependency), git SHA image tagging for deployment traceability, `kubectl set image` for rolling updates, `kubectl rollout status` for deployment verification, and idempotent namespace management. Applied production patterns: DockerHub credentials via GitHub Secrets, KUBECONFIG secret for cluster access, concurrency control, gunicorn + non-root Dockerfile, and resource limits/health probes on Kubernetes Deployments. Documented rollback automation and ArgoCD as a GitOps upgrade path.

---

## GitHub Project Description

GitHub Actions CI/CD for Kubernetes — Two-job pipeline (build + deploy), git SHA image tagging, DockerHub push, `kubectl set image` rolling updates, `kubectl rollout status` verification, namespace isolation, resource limits, health probes, concurrency control, and documented rollback + ArgoCD upgrade paths.

---

## How to Explain in an Interview (30 Seconds)

"I built a CI/CD pipeline using GitHub Actions for Kubernetes. It has two jobs: a `build` job that runs on every push and PR — it builds the Docker image and tags it with the git commit SHA, not `latest`. Then a `deploy` job runs only when code merges to main — it updates the Kubernetes Deployment using `kubectl set image` with the SHA tag and waits for `kubectl rollout status` to confirm success. I never use `latest` because you can't tell what's actually deployed. The credentials — DockerHub and KUBECONFIG — are stored as GitHub Secrets."

---

## Skills Demonstrated

- GitHub Actions (multi-job pipeline, `needs`, `if`, `outputs`)
- Docker image tagging with git SHA (`${{ github.sha }}`)
- `docker/login-action` (DockerHub authentication)
- `azure/setup-kubectl` (kubectl setup in GitHub Actions)
- KUBECONFIG as GitHub Secret (cluster access)
- `kubectl set image` (rolling image updates)
- `kubectl rollout status --timeout` (deployment verification)
- `kubectl rollout undo` (automated rollback — production pattern)
- Idempotent namespace creation (`--dry-run=client -o yaml | apply`)
- Concurrency control (`concurrency`, `cancel-in-progress`)
- Kubernetes namespace isolation (`cicd-demo`)
- Resource requests/limits on Deployments
- `livenessProbe` and `readinessProbe`
- Gunicorn WSGI + non-root user + HEALTHCHECK in Dockerfile
- Pinned Python dependencies
- ArgoCD as GitOps alternative (production upgrade path)
