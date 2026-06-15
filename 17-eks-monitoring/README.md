# Project 17 - Monitor Amazon EKS Using Prometheus and Grafana

## Problem Statement

Your company has applications running on Amazon EKS.

Current Problems:

- No visibility into cluster health
- No CPU and Memory monitoring
- No application dashboards
- No performance insights

Build a monitoring platform using Prometheus and Grafana.

---

# Architecture

Amazon EKS
      │
      ▼
Prometheus
      │
      ▼
Metrics Collection
      │
      ▼
Grafana
      │
      ▼
Dashboards

---

# Prerequisites

- AWS Account
- EKS Cluster Running
- kubectl Installed
- Helm Installed

---

# Step 1 - Configure kubectl

aws eks update-kubeconfig --region ap-south-1 --name devops-cluster

Verify:

kubectl get nodes

Expected:

Worker Nodes Ready

---

# Step 2 - Add Helm Repository

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

Verify:

helm repo list

---

# Step 3 - Create Monitoring Namespace

kubectl create namespace monitoring

Verify:

kubectl get ns

---

# Step 4 - Install Prometheus

helm install prometheus prometheus-community/prometheus -n monitoring

Verify:

kubectl get pods -n monitoring

Expected:

prometheus-server Running

---

# Step 5 - Install Grafana

helm install grafana prometheus-community/grafana -n monitoring

Verify:

kubectl get pods -n monitoring

Expected:

grafana Running

---

# Step 6 - Get Grafana Password

kubectl get secret grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode

Example:

admin123

---

# Step 7 - Access Grafana

kubectl port-forward service/grafana 3000:80 -n monitoring

Open:

http://localhost:3000

Login:

Username: admin

Password: generated-password

---

# Step 8 - Configure Prometheus Data Source

Grafana

↓

Connections

↓

Data Sources

↓

Prometheus

URL:

http://prometheus-server.monitoring.svc.cluster.local

Save & Test.

---

# Step 9 - Import Dashboard

Dashboard ID:

1860

Node Exporter Dashboard

Import.

---

# Step 10 - Deploy Sample Application

kubectl create deployment nginx --image=nginx

kubectl scale deployment nginx --replicas=5

---

# Step 11 - Observe Metrics

Verify in Grafana:

- CPU Usage
- Memory Usage
- Node Health
- Pod Health
- Network Usage

---

# Verification

Verify:

✅ EKS Running

✅ Prometheus Running

✅ Grafana Running

✅ Dashboards Working

✅ Metrics Visible

---

# Expected Output

CPU Usage

Memory Usage

Node Health

Pod Status

---

# Cleanup

helm uninstall prometheus -n monitoring

helm uninstall grafana -n monitoring

kubectl delete namespace monitoring

---

# Key Learnings

- Amazon EKS
- Prometheus
- Grafana
- Monitoring
- Observability
- Dashboards
- Helm
- Kubernetes Metrics
