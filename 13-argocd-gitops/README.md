# Project 13 - Deploy Applications Using ArgoCD (GitOps)

## Problem Statement

Your company deploys applications to Kubernetes manually.

Current Problems:

- Manual kubectl apply
- No deployment history
- Configuration drift
- Difficult rollback process

Build a GitOps solution using ArgoCD.

---

## Architecture

Developer
    │
    ▼
GitHub Repository
    │
    ▼
ArgoCD
    │
    ▼
Kubernetes Cluster
    │
    ▼
Application

---

## Prerequisites

- Kubernetes Cluster
- Minikube
- kubectl
- GitHub Account

---

## Step 1 - Create Namespace

kubectl create namespace argocd

---

## Step 2 - Install ArgoCD

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Verify:

kubectl get pods -n argocd

Expected:

All ArgoCD Pods Running

---

## Step 3 - Expose ArgoCD UI

kubectl port-forward svc/argocd-server -n argocd 8080:443

Open:

https://localhost:8080

---

## Step 4 - Get Admin Password

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

---

## Step 5 - Create Application Repository

argocd-demo/

├── deployment.yaml
└── service.yaml

---

## Step 6 - Create Deployment

Use deployment.yaml provided in this project.

---

## Step 7 - Create Service

Use service.yaml provided in this project.

---

## Step 8 - Push to GitHub

git add .

git commit -m "Initial ArgoCD App"

git push

---

## Step 9 - Create ArgoCD Application

ArgoCD UI

↓

New Application

Provide:

Repository URL

Path

Cluster URL

Namespace

---

## Step 10 - Sync Application

Click:

SYNC

Expected:

Application Healthy

Application Synced

---

## Step 11 - Verify Deployment

kubectl get pods

Expected:

nginx pods running

---

## Step 12 - Update Application

Change:

replicas: 3

Commit and Push.

Expected:

ArgoCD automatically syncs changes

---

## Verification

Verify:

✅ ArgoCD Running

✅ Repository Connected

✅ Application Synced

✅ Auto Deployment Working

---

## Expected Output

Healthy

Synced

---

## Cleanup

kubectl delete namespace argocd

---

## Key Learnings

- GitOps
- ArgoCD
- Continuous Delivery
- Kubernetes
- Deployment Automation
- Rollbacks
- Drift Detection
