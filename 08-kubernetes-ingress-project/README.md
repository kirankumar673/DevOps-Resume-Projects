# Project 08 - Expose Kubernetes Applications Using Ingress

## Problem Statement

Your company has deployed multiple applications on Kubernetes.

Current Problems:

- Each application requires a separate NodePort
- Difficult to manage URLs
- No centralized entry point
- Not production ready

Build a solution using Kubernetes Ingress.

---

## Architecture

User
 │
 ▼
Ingress Controller
 │
 ├── /app1
 │      │
 │      ▼
 │   App 1 Service
 │
 └── /app2
        │
        ▼
     App 2 Service

---

## Prerequisites

- Minikube Installed
- kubectl Installed
- Kubernetes Cluster Running

---

## Step 1 - Start Kubernetes

minikube start

Verify:

kubectl get nodes

Expected:

minikube Ready

---

## Step 2 - Enable Ingress

minikube addons enable ingress

Verify:

kubectl get pods -n ingress-nginx

Expected:

ingress-nginx-controller Running

---

## Step 3 - Deploy Application 1

Create:

app1-deployment.yaml

app1-service.yaml

---

## Step 4 - Deploy Application 2

Create:

app2-deployment.yaml

app2-service.yaml

---

## Step 5 - Create Ingress

Create:

ingress.yaml

---

## Step 6 - Deploy Resources

kubectl apply -f .

Verify:

kubectl get ingress

Expected:

app-ingress

---

## Step 7 - Get Ingress IP

minikube ip

Example:

192.168.49.2

---

## Step 8 - Test Application

Open:

http://MINIKUBE-IP/app1

Expected:

Application 1

Open:

http://MINIKUBE-IP/app2

Expected:

Application 2

---

## Verification

Verify:

✅ Ingress Controller Running

✅ App1 Accessible

✅ App2 Accessible

✅ URL Routing Working

---

## Expected Output

/app1 → Application 1

/app2 → Application 2

---

## Cleanup

kubectl delete -f .

Stop Cluster:

minikube stop

---

## Key Learnings

- Kubernetes Ingress
- URL Routing
- Reverse Proxy
- Ingress Controller
- Service Exposure
- Production Networking
