# DevOps Resume Projects

A collection of **25 production-grade DevOps projects** built to demonstrate real-world skills across Cloud Infrastructure, Containers, Kubernetes, CI/CD, Security, GitOps, Observability, and Platform Engineering.

Each project includes:
- ✅ Production-grade source code and configuration files
- ✅ Step-by-step README anyone can follow
- ✅ Resume points (Fresher + Experienced DevOps Engineer tiers)
- ✅ Interview answer scripts
- ✅ Production notes and upgrade paths

---

## Tech Stack

![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=githubactions&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=flat&logo=argo&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?style=flat&logo=sonarqube&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat&logo=grafana&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)

---

## Projects Overview

### ☁️ Cloud & Infrastructure

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 01 | [Static Website on AWS S3](./01-static-website-s3/) | AWS S3, CloudFront | S3 hosting, bucket policy, public access, HTTPS upgrade path |
| 02 | [EC2 Nginx Web Server](./02-ec2-nginx-project/) | AWS EC2, Nginx, Ubuntu | SSH, security groups, Nginx, systemctl, SCP, Certbot |
| 10 | [Terraform AWS Infrastructure](./10-terraform-aws-project/) | Terraform, AWS | VPC, EC2, SG, typed variables, outputs, remote state |
| 11 | [Terraform EC2 + Nginx](./11-terraform-ec2-nginx/) | Terraform, EC2, Nginx | user-data.sh, provisioning, outputs, state management |
| 19 | [AWS Three-Tier Architecture](./19-aws-three-tier-architecture/) | Terraform, VPC, EC2, ALB, RDS | SG chaining, DB subnet isolation, NAT, ALB target group, RDS Multi-AZ |
| 20 | [Terraform Modules](./20-terraform-modules/) | Terraform | Module output chaining, DRY IaC, versioned modules, Registry publishing |

---

### 🐳 Docker & Containers

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 04 | [Dockerize Python App](./04-dockerize-python-app/) | Docker, Python, Flask | Dockerfile best practices, layer caching, non-root user, gunicorn, HEALTHCHECK |
| 05 | [Docker Compose Multi-Container](./05-docker-compose-project/) | Docker Compose, Nginx, Flask, PostgreSQL | Multi-service orchestration, healthchecks, named volumes, `.env` secrets |
| 24 | [Nexus Container Registry](./24-nexus-container-registry/) | Nexus, Docker, Jenkins, Kubernetes | Private registry, Docker hosted repo, insecure-registries, JVM tuning |

---

### ☸️ Kubernetes

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 06 | [Kubernetes Python App](./06-kubernetes-python-app/) | Kubernetes, Minikube, kubectl | Deployment, Service, namespace, resource limits, liveness/readiness probes |
| 07 | [Kubernetes Voting App](./07-kubernetes-voting-app/) | Kubernetes, Redis, PostgreSQL | Multi-tier K8s architecture, Secrets, service discovery, namespace isolation |
| 08 | [Kubernetes Ingress](./08-kubernetes-ingress-project/) | Kubernetes, Nginx Ingress | `ingressClassName`, path-based routing, `rewrite-target`, TLS upgrade path |

---

### 🔄 CI/CD Pipelines

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 03 | [GitHub Actions CI/CD](./03-github-actions-project/) | GitHub Actions, AWS S3 | Multi-job workflows, `needs`, `concurrency`, OIDC, branch protection, SARIF |
| 12 | [CI/CD for Kubernetes](./12-cicd-kubernetes/) | GitHub Actions, Docker, Kubernetes | SHA tagging, `kubectl set image`, rollout status, namespace isolation |
| 21 | [Jenkins Kubernetes CI/CD](./21-jenkins-kubernetes-cicd/) | Jenkins, Docker, Kubernetes | `withCredentials`, git SHA tagging, `rollout status`, auto-rollback `post` block |
| 22 | [SonarQube + Jenkins](./22-sonarqube-jenkins/) | Jenkins, SonarQube, Docker, K8s | `withSonarQubeEnv`, `waitForQualityGate`, `timeout`, Quality Gate as pipeline blocker |

---

### 🔒 DevSecOps & Security

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 14 | [DevSecOps with Trivy](./14-devsecops-trivy/) | GitHub Actions, Trivy, Docker | `exit-code 1`, SARIF upload, `ignore-unfixed`, pinned action versions, supply chain security |
| 23 | [Complete DevSecOps Pipeline](./23-complete-devsecops/) | Jenkins, SonarQube, Trivy, ArgoCD, EKS | 5-stage pipeline, Quality Gate + CVE gate, `archiveArtifacts`, GitOps update, `[skip ci]` |

---

### 🔀 GitOps

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 13 | [ArgoCD GitOps](./13-argocd-gitops/) | ArgoCD, Kubernetes, Minikube | Auto-sync, selfHeal, drift detection demo, GitOps principles |
| 16 | [EKS ArgoCD GitOps](./16-eks-argocd-gitops/) | ArgoCD, Amazon EKS | GitOps on real AWS cluster, AWS ELB provisioning, ApplicationSets |

---

### 🚀 Amazon EKS

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 15 | [Terraform EKS](./15-terraform-eks/) | Terraform, Amazon EKS | VPC K8s subnet tags, NAT, IAM roles, managed node group, Cluster Autoscaler |
| 17 | [EKS Monitoring](./17-eks-monitoring/) | Prometheus, Grafana, EKS | `kube-prometheus-stack`, Node Exporter DaemonSet, PromQL, EBS PVC, Alertmanager |
| 18 | [EKS ELK Logging](./18-eks-elk-logging/) | ELK Stack, EKS, Helm | Filebeat DaemonSet, Kibana KQL, index patterns, Fluent Bit vs Filebeat |

---

### 📊 Monitoring & Logging

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 09 | [Kubernetes Monitoring](./09-kubernetes-monitoring/) | Prometheus, Grafana, Minikube | `kube-prometheus-stack`, PromQL, Dashboard 1860, PrometheusRule alerting |

---

### 🏢 Enterprise Platform

| # | Project | Tools | Key Skills |
|---|---------|-------|------------|
| 25 | [Enterprise DevSecOps Platform ⭐](./25-enterprise-devsecops-platform/) | Terraform, Jenkins, SonarQube, Trivy, Nexus, ArgoCD, EKS, Prometheus, ELK | Full platform integration — capstone project |

---

## Skills Matrix

| Skill Area | Tools Covered |
|------------|--------------|
| **Cloud** | AWS EC2, S3, VPC, RDS, ALB, EKS, IAM, CloudFront, ACM, Route 53 |
| **IaC** | Terraform (providers, modules, state, workspaces, remote backend) |
| **Containers** | Docker, Docker Compose, Dockerfile best practices, Nexus, ECR |
| **Kubernetes** | Deployments, Services, Ingress, Namespaces, ConfigMaps, Secrets, RBAC |
| **CI/CD** | Jenkins Declarative Pipeline, GitHub Actions, multi-job workflows |
| **DevSecOps** | Trivy, SonarQube, SARIF, SBOM, supply chain security, OIDC |
| **GitOps** | ArgoCD (auto-sync, selfHeal, prune, ApplicationSets) |
| **Observability** | Prometheus, Grafana, PromQL, kube-prometheus-stack, Alertmanager |
| **Logging** | ELK Stack, Filebeat DaemonSet, Kibana KQL, Fluent Bit, OpenSearch |
| **Languages** | Python (Flask), Bash, YAML, HCL |

---

## How to Use This Repository

### For Job Seekers
1. Start with **Project 01** and work through sequentially
2. Each project's `Resume-Points.md` has ready-to-use bullet points for your CV
3. Use the **"How to Explain in an Interview"** section to prepare your answers
4. The **Experienced DevOps Engineer** tier is suitable for 2+ years experience claims

### For Interviewers
Each project demonstrates:
- Real infrastructure/code — not just diagrams
- Production patterns (security, reliability, scalability)
- Understanding of WHY decisions were made (documented in READMEs)

### Learning Path

```
Beginner:    01 → 02 → 03 → 04 → 05
Intermediate: 06 → 07 → 08 → 09 → 10 → 11 → 12 → 13 → 14
Advanced:    15 → 16 → 17 → 18 → 19 → 20 → 21 → 22 → 23 → 24
Capstone:    25
```

---

## Repository Structure

```
DevOps-Resume-Projects/
├── 01-static-website-s3/
│   ├── README.md               ← Step-by-step instructions
│   ├── Resume-Points.md        ← CV bullets + interview script
│   ├── source-code/            ← Application files
│   └── bucket-policy.json      ← Infrastructure config
│
├── 02-ec2-nginx-project/       ← Same structure per project
│   ...
│
└── 25-enterprise-devsecops-platform/
    ├── README.md
    ├── Resume-Points.md
    ├── application/            ← Flask app (production Dockerfile)
    ├── jenkins/                ← 7-stage Jenkinsfile
    ├── kubernetes/             ← Deployment, Service, Ingress, Namespace
    ├── argocd/                 ← ArgoCD Application with auto-sync
    ├── terraform/              ← Modular: vpc, eks, alb, security-groups
    ├── sonarqube/              ← sonar-project.properties
    ├── monitoring/             ← Prometheus + Grafana install guide
    ├── logging/                ← ELK Stack install guide
    ├── nexus/                  ← Nexus setup guide
    └── diagrams/               ← Full architecture ASCII diagram
```

---

## Production Patterns Applied Across All Projects

| Pattern | Projects |
|---------|---------|
| Non-root Docker user | 04, 05, 06, 12, 14, 21, 22, 23, 24, 25 |
| Pinned image/dependency versions | All |
| `withCredentials` (no hardcoded secrets) | 21, 22, 23, 24, 25 |
| `TF_VAR_` for Terraform secrets | 10, 11, 15, 19, 20, 25 |
| Git SHA image tagging | 12, 14, 21, 22, 23, 24, 25 |
| `kubectl rollout status` verification | 12, 21, 22, 23, 25 |
| Kubernetes resource limits | 06, 07, 08, 12, 16, 21, 22, 23, 24, 25 |
| liveness + readiness probes | 06, 07, 12, 16, 21, 22, 25 |
| ArgoCD selfHeal + prune | 13, 16, 23, 25 |
| Security Group chaining (SG reference) | 19, 25 |
| EBS-backed PVC for stateful workloads | 17, 18, 25 |

---

## License

This repository is intended for educational and portfolio purposes.

---

*Built with ❤️ for DevOps engineers at every level.*
