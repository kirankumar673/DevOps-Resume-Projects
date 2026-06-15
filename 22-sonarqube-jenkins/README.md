# Project 22 - Integrate SonarQube Quality Gates into Jenkins CI/CD

## Problem Statement

Your company has a CI/CD pipeline, but code quality is not checked before deployment.

Current Problems:

- Bugs reach production
- Security vulnerabilities go unnoticed
- Poor code quality
- No automated quality checks

Build a CI/CD pipeline that performs code quality analysis using SonarQube before deployment.

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
    ├── Docker Push
    └── Kubernetes Deploy
    │
    ▼
Kubernetes Cluster

---

# Prerequisites

- Jenkins Installed
- SonarQube Installed
- Docker Installed
- Kubernetes Cluster
- GitHub Repository

---

# Step 1 - Create Project Structure

22-sonarqube-jenkins/

├── README.md
├── Resume-Points.md
├── Jenkinsfile
├── sonar-project.properties
├── Dockerfile
├── deployment.yaml
├── service.yaml
└── app/
    ├── app.py
    └── requirements.txt

---

# Step 2 - Create Sample Application

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

# Step 6 - Create Jenkins Pipeline

Use Jenkinsfile provided in this project.

---

# Step 7 - Configure SonarQube in Jenkins

Manage Jenkins

↓

System

↓

SonarQube Servers

Add:

Server URL

Authentication Token

---

# Step 8 - Create Jenkins Pipeline Job

Connect GitHub Repository.

---

# Step 9 - Trigger Build

Click:

Build Now

Expected:

SonarQube Scan Successful

---

# Step 10 - Verify Quality Gate

SonarQube

↓

Projects

↓

python-app

Expected:

Quality Gate Passed

---

# Step 11 - Verify Deployment

kubectl get pods

Expected:

2 Running Pods

---

# Verification

Verify:

✅ Jenkins Running

✅ SonarQube Running

✅ Scan Successful

✅ Quality Gate Passed

✅ Deployment Successful

---

# Expected Output

Quality Gate Passed

Application Deployed

---

# Cleanup

kubectl delete deployment python-app

---

# Key Learnings

- SonarQube
- Jenkins
- Static Code Analysis
- Quality Gates
- CI/CD
- DevOps
- Code Quality
