# Resume Points — Project 25: Enterprise DevSecOps Platform (Capstone)

---

## Fresher

- Built a complete end-to-end enterprise DevSecOps platform on AWS integrating Terraform, Jenkins, SonarQube, Trivy, Nexus, ArgoCD, Amazon EKS, Prometheus/Grafana, and ELK Stack into a single automated delivery pipeline.
- Provisioned AWS infrastructure using modular Terraform: VPC with public/private subnets across 2 AZs, NAT Gateway, Security Groups (ALB, EKS nodes, Jenkins with least-privilege rules), EKS cluster with IAM roles and managed node group, and ALB with health check target group — all wired via module output chaining.
- Built a 7-stage Jenkins pipeline: Checkout → SonarQube Quality Gate → Docker Build → Trivy CVE scan (`--exit-code 1`, archived report) → Nexus push → GitOps manifest update (`sed` + `git commit [skip ci]`) → ArgoCD auto-deploys to EKS.
- Deployed Prometheus (`kube-prometheus-stack`), Grafana (Dashboard 1860 + 315), and ELK Stack (Elasticsearch + Kibana + Filebeat DaemonSet) on EKS in dedicated namespaces for full observability and centralized logging.

---

## Experienced DevOps Engineer

- Designed a production-aligned enterprise DevSecOps platform with three layers of automated security: SonarQube Quality Gate (code bugs/vulnerabilities), Trivy container scan (`--ignore-unfixed --severity HIGH,CRITICAL`), and Kubernetes RBAC namespace isolation — implementing shift-left security at every stage of the pipeline.
- Architected a GitOps separation of concerns: Jenkins handles CI (build, scan, push to Nexus) and only updates image tags in a separate GitOps manifest repository via `sed` + `git commit [skip ci]`; ArgoCD handles CD (watches manifests, auto-syncs, drift-detects, self-heals on EKS) — a true GitOps model where no CI system has direct cluster access.
- Implemented Kubernetes production patterns: RollingUpdate with `maxSurge=1, maxUnavailable=0` (zero-downtime deploys), separate `/health` (liveness) and `/ready` (readiness) probes, resource requests/limits, `ingressClassName: nginx` with TLS annotations, and ArgoCD `retry.backoff` for resilient auto-sync.
- Documented production upgrade paths: OIDC for keyless Jenkins-to-AWS authentication, Amazon Managed Prometheus + Grafana for HA observability, AWS Fluent Bit + Amazon OpenSearch for managed logging, cert-manager for automatic TLS, and S3 + DynamoDB Terraform remote state for team collaboration.

---

## LinkedIn Project Description

Built a capstone enterprise DevSecOps platform on AWS integrating 10+ tools: Terraform modular infrastructure (VPC/EKS/ALB/SGs with output chaining), 7-stage Jenkins pipeline (SonarQube Quality Gate → Trivy CVE gate → Nexus push → GitOps manifest update), ArgoCD GitOps (auto-sync, selfHeal, prune on EKS), kube-prometheus-stack observability (7d retention, EBS PVC, Dashboard 1860), and ELK Stack logging (Filebeat DaemonSet). Implemented zero-downtime RollingUpdate, separate health/readiness probes, nginx Ingress with TLS, and GitOps separation of concerns (Jenkins = CI, ArgoCD = CD — no direct cluster access from CI). Documented OIDC, AMP+AMG, and OpenSearch as production upgrade paths.

---

## GitHub Project Description

Enterprise DevSecOps Capstone — Terraform modules (VPC + EKS + ALB + SGs), 7-stage Jenkins pipeline (SonarQube gate + Trivy CVE gate + Nexus + GitOps update), ArgoCD auto-sync on EKS, kube-prometheus-stack + ELK Stack observability. Zero-downtime RollingUpdate, liveness/readiness probes, nginx Ingress TLS, GitOps separation of concerns. Full architecture diagram in diagrams/architecture.txt.

---

## How to Explain in an Interview (30 Seconds)

"This is my capstone project — a complete enterprise DevSecOps platform on AWS. I provisioned the infrastructure using modular Terraform — VPC, EKS, ALB, Security Groups all as separate modules wired together with output chaining. The CI pipeline in Jenkins has three security gates: SonarQube blocks bad code quality, Trivy blocks container images with fixable HIGH or CRITICAL CVEs, and the image only reaches Nexus if both pass. Instead of deploying directly from Jenkins, the pipeline updates the image tag in a separate GitOps manifest repository and ArgoCD picks that up and deploys to EKS automatically. For observability, I have kube-prometheus-stack with Grafana showing real-time cluster metrics and ELK with Filebeat DaemonSet collecting logs from every pod. The key design principle is that Jenkins never touches the cluster directly — ArgoCD owns all deployments, which gives us full audit history and automatic drift correction."

---

## Skills Demonstrated

**Infrastructure as Code**
- Terraform modular architecture (vpc, security-groups, eks, alb modules)
- Module output chaining (no hardcoded values, no direct resource at root)
- EKS with private subnets, IAM roles, managed node group, control plane logging
- Security Group least-privilege rules (ALB SG → EKS nodes SG → Jenkins SG)
- `sensitive = true` variables, `TF_VAR_` for secrets

**CI/CD — Jenkins**
- 7-stage declarative pipeline with `options`, `environment`, `when`, `post`
- `disableConcurrentBuilds()`, `buildDiscarder`, `timeout` (pipeline hygiene)
- `withSonarQubeEnv` + `waitForQualityGate abortPipeline: true`
- Trivy `--exit-code 1 --ignore-unfixed` + `archiveArtifacts`
- `withCredentials` + `--password-stdin` (secure auth)
- Git SHA image tagging, `cleanWs()` post cleanup

**Security (DevSecOps)**
- SonarQube Quality Gate (code quality + vulnerability detection)
- Trivy container scanning (CVE blocking, audit reports)
- GitOps separation: Jenkins never accesses cluster directly
- Namespace isolation per concern (`enterprise-devsecops`, `monitoring`, `logging`, `argocd`)

**GitOps — ArgoCD**
- `automated.prune`, `selfHeal`, `CreateNamespace=true`
- `resources-finalizer.argocd.argoproj.io` (cascade delete)
- Retry with exponential backoff
- `[skip ci]` commit strategy (no CI loop)

**Kubernetes**
- RollingUpdate (`maxSurge=1, maxUnavailable=0`) — zero-downtime deploys
- Separate liveness (`/health`) and readiness (`/ready`) probes
- Resource requests and limits
- nginx Ingress with `ingressClassName`, TLS, `ssl-redirect`
- cert-manager for automatic Let's Encrypt certificates

**Observability**
- `kube-prometheus-stack` (Prometheus + Grafana + Node Exporter + Alertmanager)
- EBS-backed PVC for Prometheus data persistence
- Grafana Dashboard 1860 (Node Exporter) + 315 (K8s Cluster)
- ELK Stack — Filebeat DaemonSet, Kibana `filebeat-*` index pattern, KQL
- Amazon Managed Prometheus + Grafana (production alternative)
- AWS Fluent Bit + Amazon OpenSearch (production logging alternative)

**Production Patterns**
- OIDC keyless Jenkins-to-AWS authentication
- S3 + DynamoDB Terraform remote state
- Nexus private registry with HTTPS reverse proxy upgrade path
- cert-manager automatic TLS management
