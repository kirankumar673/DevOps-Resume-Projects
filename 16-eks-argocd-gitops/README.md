# Project 16 - Deploy Applications to Amazon EKS Using ArgoCD (GitOps)

## Problem Statement

Your company has successfully provisioned an Amazon EKS cluster using Terraform.

Current Problems:

- Developers manually deploy applications
- Deployment inconsistencies
- Difficult rollback process
- No GitOps workflow

Build a GitOps solution using ArgoCD on Amazon EKS.

---

# Architecture

Developer
    │
    ▼
GitHub Repository
    │
    ▼
ArgoCD
    │
    ▼
Amazon EKS
    │
    ▼
Application Pods

---

# Prerequisites

- AWS Account
- EKS Cluster Running
- kubectl Installed
- ArgoCD Installed
- GitHub Repository

---

# Step 1 - Verify EKS Cluster

aws eks update-kubeconfig --region ap-south-1 --name devops-cluster

Verify:

kubectl get nodes

Expected:

worker nodes ready

---

# Step 2 - Install ArgoCD

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Verify:

kubectl get pods -n argocd

Expected:

argocd-server running
argocd-repo-server running
argocd-application-controller running

---

# Step 3 - Access ArgoCD UI

kubectl port-forward svc/argocd-server -n argocd 8080:443

Open:

https://localhost:8080

---

# Step 4 - Get ArgoCD Password

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

Login:

Username: admin

Password: generated password

---

# Step 5 - Create Application Repository

16-eks-argocd-app/

├── deployment.yaml
└── service.yaml

---

# Step 6 - Create Deployment

Use deployment.yaml provided in this project.

---

# Step 7 - Create Service

Use service.yaml provided in this project.

---

# Step 8 - Push Repository

git add .

git commit -m "Initial GitOps Deployment"

git push

---

# Step 9 - Create ArgoCD Application

Application Name: nginx-app

Repository URL:

https://github.com/USERNAME/16-eks-argocd-app

Path:

/

Namespace:

default

---

# Step 10 - Sync Application

Click:

SYNC

Expected:

Healthy

Synced

---

# Step 11 - Verify Deployment

kubectl get pods

Expected:

nginx pod running

kubectl get svc

Expected:

LoadBalancer created

---

# Step 12 - Test GitOps

Change:

replicas: 2

to

replicas: 5

Commit:

git add .

git commit -m "Scale application"

git push

Expected:

ArgoCD syncs automatically

5 pods running

---

# Verification

Verify:

✅ EKS Running

✅ ArgoCD Running

✅ GitHub Connected

✅ Application Synced

✅ Auto Deployment Working

---

# Expected Output

Healthy

Synced

LoadBalancer Available

---

# Cleanup

kubectl delete namespace argocd

Delete Application from ArgoCD.

---

# Key Learnings

- Amazon EKS
- ArgoCD
- GitOps
- Kubernetes
- Continuous Delivery
- AWS Load Balancer
- Deployment Automation
