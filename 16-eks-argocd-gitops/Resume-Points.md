# Resume Points — Project 16: EKS + ArgoCD GitOps

---

## Fresher

- Implemented a GitOps deployment workflow on Amazon EKS using ArgoCD — all application changes made through Git commits, never manual `kubectl apply`.
- Deployed ArgoCD on EKS and configured an Application watching a GitHub repository to auto-sync Kubernetes manifests to the `eks-argocd-demo` namespace.
- Demonstrated that a `LoadBalancer` service on EKS provisions a real AWS Elastic Load Balancer automatically — unlike Minikube which requires port-forwarding.
- Tested drift detection: manually scaled the deployment with `kubectl scale`, observed ArgoCD auto-restore to the Git-defined replica count.

---

## Experienced DevOps Engineer

- Deployed a production-aligned GitOps platform on Amazon EKS using ArgoCD with Automatic sync policy, connecting a GitHub repository as the source of truth and `eks-argocd-demo` as the isolated application namespace.
- Demonstrated all four GitOps principles on a real cloud cluster: declarative configuration in Git, automated convergence, drift detection, and self-healing — contrasting with the Minikube environment in Project 13.
- Pinned the nginx image to `nginx:1.27` (not `latest`), added CPU/memory resource requests/limits, and configured a `readinessProbe` on the GitOps-managed manifests for production alignment.
- Documented production upgrade paths: AWS Load Balancer Controller for ALB/HTTPS, ArgoCD Ingress with cert-manager TLS, GitHub webhooks for instant sync, and ArgoCD ApplicationSets for multi-environment deployments.

---

## LinkedIn Project Description

Deployed a GitOps workflow on Amazon EKS using ArgoCD — Git as single source of truth, automatic sync on commit, drift detection, and self-healing on a production AWS cluster. Demonstrated that EKS `LoadBalancer` services provision real AWS ELBs automatically. Configured ArgoCD Application with auto-sync, namespace isolation, pinned image versions, resource limits, and readiness probes. Documented AWS Load Balancer Controller, cert-manager TLS Ingress, GitHub webhooks, and ArgoCD ApplicationSets as production patterns.

---

## GitHub Project Description

EKS ArgoCD GitOps — Production GitOps on Amazon EKS: ArgoCD auto-sync from GitHub, real AWS Load Balancer provisioning, namespace isolation, pinned nginx:1.27, resource limits, readiness probes. Includes drift detection demo and documented ALB Controller + ApplicationSets upgrade paths.

---

## How to Explain in an Interview (30 Seconds)

"I deployed ArgoCD on Amazon EKS and set up a GitOps workflow — push to Git, ArgoCD syncs to the cluster automatically, no `kubectl apply` needed. The main difference from Minikube is that a `LoadBalancer` service on EKS actually provisions a real AWS Load Balancer with an external DNS name. I also tested drift detection — scaled the deployment manually and ArgoCD restored it to what's in Git within a few minutes. In production, you'd expose ArgoCD itself via an Ingress with TLS and configure a GitHub webhook for instant sync instead of polling every 3 minutes."

---

## Skills Demonstrated

- Amazon EKS GitOps workflow
- ArgoCD on EKS (installation, Application configuration)
- GitOps principles (declarative, automated, drift detection, self-healing)
- `LoadBalancer` service on EKS → AWS ELB/NLB auto-provisioning
- ArgoCD Automatic sync policy
- Namespace isolation (`eks-argocd-demo`)
- Pinned image versions in GitOps manifests (`nginx:1.27`)
- Resource requests/limits on GitOps-managed deployments
- `readinessProbe` on Kubernetes Deployments
- Drift detection and self-healing demonstration
- AWS Load Balancer Controller (ALB with HTTPS — production)
- ArgoCD Ingress with cert-manager TLS (production)
- GitHub webhook for instant ArgoCD sync
- ArgoCD ApplicationSets (multi-environment deployments)
