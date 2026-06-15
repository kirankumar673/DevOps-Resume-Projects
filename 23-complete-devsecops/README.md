# Project 23 - Complete DevSecOps Pipeline on Amazon EKS

## Problem Statement

Your company deploys applications to Kubernetes.

Current Problems:

- No code quality validation
- No vulnerability scanning
- Manual deployments
- Security risks
- No GitOps

Build a complete DevSecOps platform.

---

# Architecture

Developer
    │
    ▼
GitHub
    │
    ▼
Jenkins
    │
    ├── Build
    ├── SonarQube Scan
    ├── Quality Gate
    ├── Docker Build
    ├── Trivy Scan
    ├── Docker Push
    └── GitOps Update
    │
    ▼
Git Repository
    │
    ▼
ArgoCD
    │
    ▼
Amazon EKS

---

# Prerequisites

- AWS Account
- Amazon EKS Cluster
- Jenkins Installed
- SonarQube Installed
- Trivy Installed
- ArgoCD Installed
- Docker Installed
- DockerHub Account

---

# Step 1 - Create Project Structure

23-complete-devsecops/

├── README.md
├── Resume-Points.md
├── Jenkinsfile
├── Dockerfile
├── sonar-project.properties
├── deployment.yaml
├── service.yaml
├── app/
│   ├── app.py
│   └── requirements.txt
└── argocd/
    └── application.yaml

---

# Step 2 - Create Flask Application

Use files provided in app/ folder.

---

# Step 3 - Create SonarQube Configuration

Use sonar-project.properties provided in this project.

---

# Step 4 - Create Dockerfile

Use Dockerfile provided in this project.

---

# Step 5 - Create Kubernetes Deployment

Use deployment.yaml provided in this project.

---

# Step 6 - Create Service

Use service.yaml provided in this project.

---

# Step 7 - Create ArgoCD Application

Use argocd/application.yaml provided in this project.

---

# Step 8 - Create Jenkins Pipeline

Use Jenkinsfile provided in this project.

---

# Step 9 - Configure Jenkins

Install:

Git Plugin
Docker Plugin
SonarQube Plugin

---

# Step 10 - Trigger Pipeline

Click:

Build Now

Expected:

Pipeline Successful

---

# Step 11 - Verify SonarQube

Expected:

Quality Gate Passed

---

# Step 12 - Verify Trivy

Expected:

No Critical Vulnerabilities

---

# Step 13 - Verify ArgoCD

Expected:

Healthy

Synced

---

# Step 14 - Verify EKS Deployment

kubectl get pods

kubectl get svc

Expected:

Application Running

---

# Verification

Verify:

✅ Jenkins Running

✅ SonarQube Running

✅ Trivy Running

✅ Docker Push Successful

✅ ArgoCD Synced

✅ EKS Deployment Successful

---

# Expected Output

Quality Gate Passed

No Critical Vulnerabilities

Application Running

---

# Cleanup

kubectl delete deployment devsecops-app

---

# Key Learnings

- Jenkins
- SonarQube
- Trivy
- Docker
- ArgoCD
- Amazon EKS
- DevSecOps
- GitOps
