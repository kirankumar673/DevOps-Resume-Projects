# Project 06 - Deploy a Python Application on Kubernetes

## Problem Statement

Your company has containerized an application using Docker.

Current Problems:

- Application runs on a single container
- No auto-healing
- No scaling
- Difficult production management

Build a solution using Kubernetes.

---

## Architecture

User
  │
  ▼
Kubernetes Service
  │
  ▼
Deployment
  │
  ▼
Pod
  │
  ▼
Python Flask Application

---

## Prerequisites

- Docker Installed
- Minikube Installed
- kubectl Installed
- Basic Docker Knowledge

---

## Step 1 - Start Kubernetes Cluster

Start Minikube:

minikube start

Verify:

kubectl get nodes

Expected:

NAME       STATUS
minikube   Ready

---

## Step 2 - Create Application

Create source-code/app.py and requirements.txt

---

## Step 3 - Build Docker Image

docker build -t python-app:v1 .

Verify:

docker images

---

## Step 4 - Create Deployment

Create deployment.yaml

---

## Step 5 - Create Service

Create service.yaml

---

## Step 6 - Deploy Application

kubectl apply -f deployment.yaml

kubectl apply -f service.yaml

---

## Step 7 - Verify Resources

kubectl get pods

kubectl get deployments

kubectl get svc

---

## Step 8 - Access Application

minikube service python-app-service --url

Expected:

Hello From Kubernetes

---

## Step 9 - Scale Application

kubectl scale deployment python-app --replicas=5

Verify:

kubectl get pods

Expected:

5 Running Pods

---

## Verification

Verify:

✅ Deployment created

✅ Service created

✅ Pods running

✅ Application accessible

✅ Scaling working

---

## Expected Output

Hello From Kubernetes

---

## Cleanup

kubectl delete deployment python-app

kubectl delete service python-app-service

minikube stop

---

## Key Learnings

- Kubernetes
- Deployment
- Pod
- Service
- Scaling
- kubectl
- Minikube
