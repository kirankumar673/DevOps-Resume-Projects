# Project 21 - Build a Jenkins CI/CD Pipeline for Kubernetes

## Problem Statement

Your company deploys applications manually.

Current Problems:

- Slow deployments
- Human errors
- No automation
- Difficult rollbacks

Build a CI/CD pipeline using Jenkins.

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
    ├── Test
    ├── Docker Build
    ├── Docker Push
    └── Kubernetes Deploy
    │
    ▼
Kubernetes Cluster

---

# Prerequisites

- Jenkins Installed
- Docker Installed
- Kubernetes Cluster
- GitHub Repository
- DockerHub Account

---

# Step 1 - Create Project Structure

21-jenkins-kubernetes-cicd/

├── README.md
├── Resume-Points.md
├── Jenkinsfile
├── Dockerfile
├── deployment.yaml
├── service.yaml
├── app/
│   ├── app.py
│   └── requirements.txt

---

# Step 2 - Create Sample Application

Use files provided in app/ folder.

---

# Step 3 - Create Dockerfile

Use Dockerfile provided in this project.

---

# Step 4 - Create Kubernetes Deployment

Use deployment.yaml provided in this project.

---

# Step 5 - Create Service

Use service.yaml provided in this project.

---

# Step 6 - Create Jenkins Pipeline

Use Jenkinsfile provided in this project.

---

# Step 7 - Configure Jenkins

Install:

Docker Plugin
Kubernetes Plugin
Git Plugin

---

# Step 8 - Create Pipeline Job

Jenkins → New Item → Pipeline

Connect GitHub Repository

---

# Step 9 - Trigger Build

Click:

Build Now

Expected:

Pipeline Successful

---

# Step 10 - Verify Deployment

kubectl get pods

kubectl get svc

Expected:

2 Running Pods

---

# Step 11 - Access Application

minikube service flask-app-service --url

Expected:

Jenkins CI/CD Success

---

# Verification

Verify:

✅ Jenkins Running

✅ Docker Image Built

✅ Image Pushed

✅ Kubernetes Deployment Successful

✅ Application Accessible

---

# Expected Output

Jenkins CI/CD Success

---

# Cleanup

kubectl delete deployment flask-app

kubectl delete service flask-app-service

---

# Key Learnings

- Jenkins
- CI/CD
- Docker
- Kubernetes
- Automation
- Pipeline Design
- Continuous Delivery
