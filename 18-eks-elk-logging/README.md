# Project 18 - Centralized Logging on Amazon EKS Using ELK Stack

## Problem Statement

Your company runs applications on Amazon EKS.

Current Problems:

- Logs scattered across pods
- Difficult troubleshooting
- No centralized search
- No visibility into application errors

Build a centralized logging platform using Elasticsearch, Logstash, and Kibana.

---

# Architecture

Application Pods
       │
       ▼
Filebeat
       │
       ▼
Logstash
       │
       ▼
Elasticsearch
       │
       ▼
Kibana
       │
       ▼
Dashboard & Log Search

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

# Step 2 - Create Logging Namespace

kubectl create namespace logging

Verify:

kubectl get ns

---

# Step 3 - Add Elastic Repository

helm repo add elastic https://helm.elastic.co

helm repo update

Verify:

helm repo list

---

# Step 4 - Install Elasticsearch

helm install elasticsearch elastic/elasticsearch -n logging

Verify:

kubectl get pods -n logging

Expected:

elasticsearch-master Running

---

# Step 5 - Install Kibana

helm install kibana elastic/kibana -n logging

Verify:

kubectl get pods -n logging

Expected:

kibana Running

---

# Step 6 - Install Logstash

helm install logstash elastic/logstash -n logging

Verify:

kubectl get pods -n logging

Expected:

logstash Running

---

# Step 7 - Install Filebeat

helm install filebeat elastic/filebeat -n logging

Verify:

kubectl get daemonset -n logging

Expected:

filebeat Running on every node

---

# Step 8 - Access Kibana

kubectl port-forward service/kibana-kibana 5601:5601 -n logging

Open:

http://localhost:5601

---

# Step 9 - Deploy Sample Application

kubectl create deployment nginx --image=nginx

Generate logs:

kubectl logs deployment/nginx

---

# Step 10 - Search Logs in Kibana

Open:

Discover

Search:

nginx

Expected:

Application logs visible

---

# Step 11 - Create Dashboard

Kibana

↓

Dashboard

↓

Create Dashboard

Add:

- Error Logs
- Warning Logs
- Request Volume

---

# Verification

Verify:

✅ Elasticsearch Running

✅ Logstash Running

✅ Filebeat Running

✅ Kibana Running

✅ Logs Visible

---

# Expected Output

Centralized Logs

Searchable Logs

Application Insights

---

# Cleanup

helm uninstall elasticsearch -n logging

helm uninstall kibana -n logging

helm uninstall logstash -n logging

helm uninstall filebeat -n logging

kubectl delete namespace logging

---

# Key Learnings

- ELK Stack
- Elasticsearch
- Logstash
- Kibana
- Filebeat
- Centralized Logging
- Log Analysis
- Kubernetes Logging
