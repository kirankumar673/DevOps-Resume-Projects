# Project 07 - Deploy a Voting Application on Kubernetes

## Problem Statement

Your company wants to deploy a voting application.

Requirements:

- Users can vote
- Votes must be stored
- Results must be displayed
- Application should scale easily
- Application should be highly available

Build the solution using Kubernetes.

---

## Architecture

User
 │
 ▼
Vote App
 │
 ▼
Redis
 │
 ▼
Worker
 │
 ▼
PostgreSQL
 │
 ▼
Result App

---

## Prerequisites

- Docker Installed
- Kubernetes Cluster
- kubectl Installed
- Minikube Installed

---

## Step 1 - Create Namespace

Create namespace.yaml

Deploy:

kubectl apply -f namespace.yaml

Verify:

kubectl get ns

---

## Step 2 - Deploy Redis

Create:

redis-deployment.yaml

redis-service.yaml

---

## Step 3 - Deploy PostgreSQL

Create:

postgres-deployment.yaml

postgres-service.yaml

---

## Step 4 - Deploy Vote Application

Create:

vote-deployment.yaml

vote-service.yaml

---

## Step 5 - Deploy Worker

Create:

worker-deployment.yaml

---

## Step 6 - Deploy Result Application

Create:

result-deployment.yaml

result-service.yaml

---

## Step 7 - Deploy Everything

kubectl apply -f .

Verify:

kubectl get all

Expected:

redis
postgres
vote
worker
result

running.

---

## Step 8 - Access Application

Vote App:

minikube service vote --url

Result App:

minikube service result --url

---

## Verification

Verify:

✅ Redis Running

✅ PostgreSQL Running

✅ Vote App Running

✅ Worker Running

✅ Result App Running

---

## Expected Output

Vote:

Cats

Dogs

Result:

Live Voting Results

---

## Cleanup

kubectl delete namespace voting-app

---

## Key Learnings

- Multi-Tier Applications
- Kubernetes Deployments
- Kubernetes Services
- Service Discovery
- Redis
- PostgreSQL
- Scaling
- Real World Architecture
