# Project 09 - Monitor Kubernetes Cluster Using Prometheus and Grafana

## Problem Statement

Your company has deployed applications on Kubernetes.

Current Problems:

- No visibility into cluster health
- No CPU monitoring
- No Memory monitoring
- No dashboards
- No performance insights

Build a monitoring solution using Prometheus and Grafana.

---

## Architecture

Kubernetes Cluster
       │
       ▼
Prometheus
       │
       ▼
Metrics Storage
       │
       ▼
Grafana
       │
       ▼
Dashboards

---

## Prerequisites

- Minikube Installed
- kubectl Installed
- Helm Installed
- Kubernetes Cluster Running

---

## Step 1 - Start Kubernetes

minikube start

Verify:

kubectl get nodes

Expected:

minikube Ready

---

## Step 2 - Add Helm Repository

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

Verify:

helm repo list

---

## Step 3 - Install Prometheus

helm install prometheus prometheus-community/prometheus

Verify:

kubectl get pods

Expected:

prometheus-server Running

---

## Step 4 - Install Grafana

helm install grafana prometheus-community/grafana

Verify:

kubectl get pods

Expected:

grafana Running

---

## Step 5 - Get Grafana Password

kubectl get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode

Example:

admin123

---

## Step 6 - Expose Grafana

kubectl port-forward service/grafana 3000:80

Open:

http://localhost:3000

Login:

Username: admin

Password: <password>

---

## Step 7 - Import Dashboard

Grafana

↓

Dashboards

↓

Import

Dashboard ID:

1860

(Node Exporter Dashboard)

---

## Step 8 - Generate Load

kubectl run nginx --image=nginx

Verify:

kubectl get pods

---

## Step 9 - Observe Metrics

Open Grafana.

Verify:

- CPU Usage
- Memory Usage
- Pod Count
- Node Health

---

## Verification

Verify:

✅ Prometheus Running

✅ Grafana Running

✅ Dashboards Visible

✅ Metrics Collected

---

## Expected Output

Grafana Dashboard showing:

CPU Usage

Memory Usage

Pod Status

Cluster Health

---

## Cleanup

helm uninstall prometheus

helm uninstall grafana

Stop Cluster:

minikube stop

---

## Key Learnings

- Prometheus
- Grafana
- Helm
- Metrics
- Monitoring
- Observability
- Dashboards
