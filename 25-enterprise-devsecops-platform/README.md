# Project 25 - Enterprise DevSecOps Platform on AWS (Capstone)

## Problem Statement

Your company needs a production-grade, end-to-end DevSecOps platform on AWS that handles the complete software delivery lifecycle — from developer code push to a running, monitored, and secure application on Kubernetes.

Requirements:
- Infrastructure as Code (Terraform)
- Automated CI/CD (Jenkins)
- Code quality gates (SonarQube)
- Container security scanning (Trivy)
- Private artifact registry (Nexus)
- GitOps deployment (ArgoCD)
- Kubernetes orchestration (Amazon EKS)
- Observability (Prometheus + Grafana)
- Centralized logging (ELK Stack)

---

## Architecture

```
Developer → git push → GitHub
                           │
                    Jenkins CI (7 stages)
                           │
          ┌────────────────┼────────────────────┐
          ▼                ▼                    ▼
    SonarQube          Trivy Scan           Nexus Registry
  (Quality Gate)   (CVE Security Gate)   (Private Docker)
                           │
                  GitOps Manifest Update
                           │
                        ArgoCD
                           │
                    Amazon EKS Cluster
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
          Application  Prometheus    ELK Stack
                         Grafana      Kibana
```

See `diagrams/architecture.txt` for the full detailed diagram.

---

## Project Structure

```
25-enterprise-devsecops-platform/
├── application/
│   ├── app.py              ← Flask app (/health, /ready, /metrics endpoints)
│   ├── requirements.txt    ← Pinned: flask==3.0.3, gunicorn==22.0.0
│   ├── Dockerfile          ← Layer caching, non-root, HEALTHCHECK, gunicorn
│   └── .dockerignore
│
├── jenkins/
│   └── Jenkinsfile         ← 7-stage enterprise pipeline
│
├── kubernetes/
│   ├── namespace.yaml      ← enterprise-devsecops namespace
│   ├── deployment.yaml     ← RollingUpdate, resources, liveness/readiness probes
│   ├── service.yaml        ← ClusterIP (Ingress handles external traffic)
│   └── ingress.yaml        ← nginx, TLS, host-based routing
│
├── argocd/
│   └── application.yaml   ← Auto-sync, selfHeal, prune, retry backoff
│
├── terraform/
│   ├── main.tf             ← Root module (wires vpc, sg, eks, alb)
│   ├── variables.tf        ← All typed variables
│   ├── outputs.tf          ← Cluster, ALB, VPC outputs
│   ├── terraform.tfvars
│   ├── vpc/main.tf         ← VPC, subnets, IGW, NAT, route tables, K8s tags
│   ├── security-groups/    ← ALB, EKS nodes, Jenkins SGs
│   ├── eks/main.tf         ← IAM roles, EKS cluster, managed node group
│   └── alb/main.tf         ← ALB, target group (/health check), listener
│
├── sonarqube/
│   └── sonar-project.properties
│
├── monitoring/
│   ├── prometheus-install.md   ← kube-prometheus-stack with EBS PVC
│   └── grafana-install.md      ← Dashboard 1860, 315, PromQL queries
│
├── logging/
│   └── elk-install.md          ← Elasticsearch + Kibana + Filebeat DaemonSet
│
├── nexus/
│   └── nexus-setup.md          ← Docker Hosted Repository on port 8082
│
└── diagrams/
    └── architecture.txt        ← Full ASCII architecture diagram
```

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Terraform | ≥ 1.3.0 | [hashicorp.com](https://developer.hashicorp.com/terraform/install) |
| AWS CLI | ≥ 2.0 | [aws.amazon.com](https://aws.amazon.com/cli/) |
| kubectl | ≥ 1.29 | [kubernetes.io](https://kubernetes.io/docs/tasks/tools/) |
| Helm | ≥ 3.12 | [helm.sh](https://helm.sh/docs/intro/install/) |
| Docker | ≥ 24.0 | [docker.com](https://docs.docker.com/get-docker/) |
| Jenkins | LTS | EC2 or Docker |

---

## Phase 1 — Provision AWS Infrastructure (Terraform)

### Step 1.1 - Configure AWS CLI

```bash
aws configure
aws sts get-caller-identity
```

### Step 1.2 - Update terraform.tfvars

```bash
cd terraform/
```

Edit `terraform.tfvars` — replace `YOUR_IP/32` with your actual IP:

```bash
curl ifconfig.me
```

### Step 1.3 - Initialize and Apply

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

> ⚠️ EKS + NAT Gateway takes ~15 minutes. This infrastructure costs approximately **$5–8/day**.

Expected outputs:

```
eks_cluster_name     = "enterprise-devsecops"
kubeconfig_command   = "aws eks update-kubeconfig --region ap-south-1 --name enterprise-devsecops"
alb_dns_name         = "enterprise-devsecops-alb-xxx.ap-south-1.elb.amazonaws.com"
```

### Step 1.4 - Configure kubectl

```bash
$(terraform output -raw kubeconfig_command)
kubectl get nodes
```

Expected:

```
NAME                                      STATUS   ROLES    AGE
ip-10-0-3-xx.ap-south-1.compute.internal Ready    <none>   5m
ip-10-0-4-xx.ap-south-1.compute.internal Ready    <none>   5m
```

---

## Phase 2 — Install Platform Components on EKS

### Step 2.1 - Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd -w
```

Get admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Access UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open: `https://localhost:8080` | User: `admin`

### Step 2.2 - Install NGINX Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

### Step 2.3 - Install Prometheus + Grafana

```bash
# See monitoring/prometheus-install.md for full commands
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin123 \
  --set prometheus.prometheusSpec.retention=7d
```

### Step 2.4 - Install ELK Stack

```bash
# See logging/elk-install.md for full commands
helm repo add elastic https://helm.elastic.co
kubectl create namespace logging
helm install elasticsearch elastic/elasticsearch --namespace logging \
  --set replicas=1 --set resources.limits.memory=2Gi
helm install kibana elastic/kibana --namespace logging \
  --set elasticsearchHosts=http://elasticsearch-master:9200
helm install filebeat elastic/filebeat --namespace logging
```

---

## Phase 3 — Setup Jenkins and Nexus

### Step 3.1 - Deploy Nexus

```bash
# See nexus/nexus-setup.md for full commands
# SSH into Jenkins EC2 instance
cd 25-enterprise-devsecops-platform/nexus/
docker compose up -d
```

### Step 3.2 - Configure Jenkins

Install plugins:
- Docker Pipeline
- SonarQube Scanner
- Kubernetes CLI
- Git
- Credentials Binding

Add Jenkins Credentials (Manage Jenkins → Credentials):

| ID | Type | Value |
|----|------|-------|
| `nexus-credentials` | Username/Password | Nexus admin user |
| `github-credentials` | Username/Password | GitHub token |
| `SonarQube` | Secret Text | SonarQube token |

Set Jenkins environment variables (Manage Jenkins → System):
- `NEXUS_HOST` = EC2 public IP

---

## Phase 4 — Configure ArgoCD Application

### Step 4.1 - Push manifests to GitOps repository

Push the `kubernetes/` directory to a separate GitHub repo (e.g., `enterprise-gitops-manifests`).

### Step 4.2 - Apply ArgoCD Application

Update `argocd/application.yaml` with your GitHub repo URL, then:

```bash
kubectl apply -f argocd/application.yaml
```

Verify in ArgoCD UI:

```
✅ Healthy
✅ Synced
```

---

## Phase 5 — Trigger the Pipeline

### Step 5.1 - Create Jenkins Pipeline Job

1. Jenkins → **New Item** → **Pipeline**
2. Pipeline Definition: **Pipeline script from SCM**
3. SCM: **Git** → your repository URL
4. Script Path: `25-enterprise-devsecops-platform/jenkins/Jenkinsfile`
5. Save

### Step 5.2 - Push Code to Trigger Pipeline

```bash
git add .
git commit -m "feat: initial enterprise platform deployment"
git push origin main
```

### Step 5.3 - Monitor Pipeline Stages

Jenkins → your pipeline job → Stage View:

```
Checkout → SonarQube Analysis → Quality Gate → Docker Build →
Trivy Security Scan → Push to Nexus Registry → Update GitOps Manifest
```

---

## Phase 6 — Verify Complete Platform

```bash
# EKS deployment
kubectl get all -n enterprise-devsecops

# ArgoCD
kubectl get applications -n argocd

# Monitoring
kubectl get pods -n monitoring

# Logging
kubectl get pods -n logging
```

Access Grafana:

```bash
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```

Access Kibana:

```bash
kubectl port-forward service/kibana-kibana 5601:5601 -n logging
```

---

## Verification Checklist

✅ Terraform — EKS cluster, VPC, ALB, Security Groups provisioned

✅ kubectl — both nodes `Ready`

✅ ArgoCD — Application `Healthy` + `Synced`

✅ Jenkins pipeline — all 7 stages green

✅ SonarQube — Quality Gate `Passed`

✅ Trivy — no HIGH/CRITICAL unpatched CVEs

✅ Nexus — image visible in docker-hosted repository

✅ Application — pods `Running` in `enterprise-devsecops` namespace

✅ Ingress — application accessible via host URL

✅ Prometheus — all scrape targets `up`

✅ Grafana — Dashboard 1860 showing real node metrics

✅ Kibana — `filebeat-*` index pattern, logs visible in Discover

---

## Troubleshooting

**ArgoCD shows `OutOfSync`:**
```bash
kubectl logs -n argocd deployment/argocd-repo-server | tail -20
```

**Jenkins fails at Trivy stage — CVEs found:**
- Update `FROM python:3.11-slim` to the latest patch
- Re-run `pip install --upgrade` in requirements

**Pods stuck in `ImagePullBackOff`:**
- Verify Nexus insecure-registries config on worker nodes
- Check image tag was updated in GitOps manifest

**Elasticsearch `OOMKilled`:**
- Increase instance type to `t3.large` or reduce `resources.limits.memory`

---

## Cleanup

> ⚠️ Always clean up in this order to avoid orphaned AWS resources:

```bash
# 1. Remove K8s LoadBalancer services (prevent ALB orphaning)
kubectl delete namespace enterprise-devsecops
kubectl delete namespace monitoring
kubectl delete namespace logging
kubectl delete namespace argocd
kubectl delete namespace ingress-nginx

# 2. Destroy Terraform infrastructure
cd terraform/
terraform destroy
```

---

## Production Notes

> **1. Replace Jenkins Credentials with OIDC**
> Use AWS IAM OIDC provider for keyless, short-lived credentials instead of long-lived access keys.

> **2. Use Amazon Managed Prometheus + Grafana**
> Replace self-hosted Prometheus/Grafana with AMP + AMG for HA observability without managing infrastructure.

> **3. Replace ELK with Amazon OpenSearch + Fluent Bit**
> Use `aws/aws-for-fluent-bit` DaemonSet + Amazon OpenSearch Service for managed, HA logging.

> **4. Enable Terraform Remote State**
> ```hcl
> backend "s3" {
>   bucket         = "enterprise-tfstate"
>   key            = "platform/terraform.tfstate"
>   region         = "ap-south-1"
>   dynamodb_table = "terraform-lock"
> }
> ```

> **5. Add cert-manager for Auto TLS**
> ```bash
> helm install cert-manager jetstack/cert-manager --set installCRDs=true
> ```
> Creates Let's Encrypt certificates automatically for the Ingress.

---

## Key Learnings

- End-to-end enterprise DevSecOps pipeline design and integration
- Terraform modular architecture (vpc, security-groups, eks, alb modules with output chaining)
- EKS cluster provisioning with private subnets, IAM roles, managed node group
- Jenkins declarative pipeline with `options`, `environment`, `when`, and `post` blocks
- `withSonarQubeEnv` + `waitForQualityGate abortPipeline: true` (code quality gate)
- Trivy `--exit-code 1 --ignore-unfixed` (security gate — CVE blocking)
- `archiveArtifacts` for Trivy report (compliance audit trail)
- Nexus private Docker registry with `withCredentials` + `--password-stdin`
- GitOps manifest update pattern: `sed` + `git commit [skip ci]` → ArgoCD detects
- ArgoCD `automated.prune`, `selfHeal`, `CreateNamespace=true`, retry backoff
- Kubernetes RollingUpdate strategy (`maxSurge=1`, `maxUnavailable=0`)
- liveness `/health` + readiness `/ready` probes (separate concerns)
- `kube-prometheus-stack` with EBS PVC for metrics persistence
- Filebeat DaemonSet (per-node container log collection)
- Kibana `filebeat-*` index patterns and KQL search
- cert-manager for automatic TLS on Ingress
- OIDC keyless AWS authentication (production security)
- Amazon Managed Prometheus + Grafana + OpenSearch (production observability)
