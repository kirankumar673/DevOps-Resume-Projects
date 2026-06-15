# Resume Points — Project 13: ArgoCD GitOps

---

## Fresher

- Implemented GitOps using ArgoCD to automatically sync Kubernetes deployments from a GitHub repository — eliminating manual `kubectl apply` commands.
- Configured an ArgoCD Application with Automatic sync policy, connecting a GitHub manifest repository to a Kubernetes namespace (`argocd-demo`).
- Demonstrated drift detection and self-healing: manually scaled a deployment with `kubectl scale` and observed ArgoCD automatically restoring it to the Git-defined state.
- Pinned Nginx image to `nginx:1.27` and added resource limits and readiness probes to the GitOps-managed manifests.

---

## Experienced DevOps Engineer

- Deployed ArgoCD from the official stable manifest and configured it as a GitOps operator — Git repository is the single source of truth; no direct `kubectl apply` in production.
- Demonstrated all core GitOps principles: declarative configuration in Git, automated convergence (ArgoCD syncs cluster to Git state), and self-healing (drift from desired state is auto-corrected).
- Tested the complete GitOps workflow: pushed a replica count change to Git → ArgoCD detected and applied it automatically, then simulated drift with `kubectl scale` → ArgoCD self-healed within minutes.
- Documented production upgrade paths: GitHub webhook for instant sync (vs 3-minute polling), App of Apps pattern for multi-service management, and ArgoCD Image Updater for automated image tag management.

---

## LinkedIn Project Description

Implemented a GitOps deployment workflow using ArgoCD on Kubernetes. Configured ArgoCD to monitor a GitHub repository and automatically sync Kubernetes manifests (Deployment + Service) to a dedicated namespace. Demonstrated all GitOps principles: declarative Git-driven configuration, automatic sync on commit, drift detection, and self-healing. Pinned image versions, applied resource limits, and configured health probes on managed deployments. Documented production patterns: GitHub webhooks for instant sync, App of Apps pattern, ArgoCD Image Updater, and RBAC/SSO integration.

---

## GitHub Project Description

ArgoCD GitOps — Kubernetes manifests managed as Git source of truth. ArgoCD auto-syncs on commit, detects configuration drift, and self-heals the cluster. Demonstrates declarative GitOps principles with pinned image versions, resource limits, health probes, and documented production upgrade paths (webhooks, App of Apps, Image Updater).

---

## How to Explain in an Interview (30 Seconds)

"I implemented GitOps using ArgoCD. Instead of running `kubectl apply` manually, I pushed Kubernetes manifests to a GitHub repository and configured ArgoCD to watch it. Whenever I push a change to Git, ArgoCD detects it and syncs the cluster automatically. I also tested drift detection — I manually scaled the deployment down with `kubectl scale`, and ArgoCD detected the drift and restored it back to the Git-defined state within minutes. That self-healing behaviour is one of the biggest advantages of GitOps over traditional CI/CD."

---

## Skills Demonstrated

- GitOps principles (Git as single source of truth, declarative configuration)
- ArgoCD installation from official stable manifests
- ArgoCD Application configuration (repo, path, cluster, namespace, sync policy)
- Automatic sync policy (cluster converges to Git state on every commit)
- Drift detection and self-healing (cluster auto-corrected to Git state)
- `kubectl port-forward` for accessing ArgoCD UI
- ArgoCD admin secret decoding (`base64 -d`)
- `argocd-initial-admin-secret` Kubernetes Secret
- Git-driven operations (never `kubectl apply` in production)
- GitHub webhook for instant sync (production pattern)
- App of Apps pattern (multi-service GitOps management)
- ArgoCD Image Updater (automated image tag updates in Git)
- ArgoCD RBAC + SSO integration (production security)
- Pinned Docker image versions in GitOps manifests
- Kubernetes resource limits and readiness probes
