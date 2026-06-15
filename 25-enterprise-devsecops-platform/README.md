# Project 25 - Enterprise DevSecOps Platform on AWS (Capstone)

## Problem Statement

Your company wants a complete cloud-native platform capable of:

- Continuous Integration
- Continuous Delivery
- Security Scanning
- Artifact Management
- GitOps
- Monitoring
- Logging
- Kubernetes Orchestration

Build a complete enterprise DevSecOps platform on AWS.

---

# Architecture

Developer → GitHub → Jenkins → SonarQube → Trivy → Nexus → ArgoCD → Amazon EKS → Prometheus/Grafana/ELK

---

# Execution Flow

Step 1: Provision Infrastructure using Terraform

terraform init
terraform apply

Step 2: Install ArgoCD

Step 3: Install Prometheus and Grafana

Step 4: Install ELK Stack

Step 5: Deploy Nexus

Step 6: Configure Jenkins

Step 7: Configure SonarQube

Step 8: Configure Trivy

Step 9: Push Code

Step 10: Jenkins Pipeline Executes

Step 11: ArgoCD Syncs

Step 12: Deploy Application

Step 13: Monitor Application

Step 14: Analyze Logs

---

# Verification

✅ Terraform Successful
✅ EKS Running
✅ Jenkins Running
✅ SonarQube Running
✅ Trivy Successful
✅ Nexus Running
✅ ArgoCD Synced
✅ Application Running
✅ Grafana Working
✅ Kibana Working

---

# Key Learnings

AWS
Terraform
Amazon EKS
Jenkins
SonarQube
Trivy
Nexus
ArgoCD
GitOps
DevSecOps
Prometheus
Grafana
ELK Stack
Kubernetes
Docker
