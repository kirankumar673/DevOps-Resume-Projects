# Project 12 - Build a CI/CD Pipeline for Kubernetes Using GitHub Actions

## Problem Statement

Your company has a Kubernetes application.

Current Problems:

- Developers deploy manually
- Deployment errors occur frequently
- Releases are slow
- No automation

Build a CI/CD pipeline that automatically deploys applications to Kubernetes whenever code is pushed to GitHub.

---

## Architecture

Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Build Docker Image
    ├── Push Docker Image
    └── Deploy to Kubernetes
    │
    ▼
Kubernetes Cluster

---

## Prerequisites

- GitHub Account
- DockerHub Account
- Minikube Installed
- kubectl Installed
- Docker Installed

---

## Step 1 - Create Project Structure

12-cicd-kubernetes/

├── README.md
├── Resume-Points.md
├── Dockerfile
├── deployment.yaml
├── service.yaml
├── source-code/
│   ├── app.py
│   └── requirements.txt
└── .github/
    └── workflows/
        └── deploy.yml

---

## Step 2 - Create Application

Create source-code/app.py and requirements.txt.

---

## Step 3 - Create Dockerfile

Use Dockerfile provided in this project.

---

## Step 4 - Create Kubernetes Deployment

Use deployment.yaml provided in this project.

---

## Step 5 - Create Service

Use service.yaml provided in this project.

---

## Step 6 - Configure GitHub Secrets

Repository

↓

Settings

↓

Secrets

Add:

DOCKER_USERNAME

DOCKER_PASSWORD

---

## Step 7 - Create GitHub Actions Workflow

Use .github/workflows/deploy.yml provided in this project.

---

## Step 8 - Push Code

git add .

git commit -m "Added CI/CD Pipeline"

git push

---

## Step 9 - Verify Workflow

GitHub

↓

Actions

↓

Workflow Running

Expected:

Build Successful

Push Successful

---

## Step 10 - Deploy to Kubernetes

kubectl apply -f deployment.yaml

kubectl apply -f service.yaml

---

## Step 11 - Verify Deployment

kubectl get pods

kubectl get svc

Expected:

2 Running Pods

---

## Step 12 - Access Application

minikube service python-app-service --url

Expected:

Deployed Using GitHub Actions

---

## Verification

Verify:

✅ Workflow Running

✅ Docker Image Built

✅ Docker Image Pushed

✅ Kubernetes Deployment Running

✅ Application Accessible

---

## Expected Output

Deployed Using GitHub Actions

---

## Cleanup

kubectl delete deployment python-app

kubectl delete service python-app-service

---

## Key Learnings

- GitHub Actions
- CI/CD
- DockerHub
- Docker Images
- Kubernetes Deployments
- Automation
