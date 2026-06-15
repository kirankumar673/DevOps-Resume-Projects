# Project 18 - Centralized Logging on Amazon EKS Using ELK Stack

## Problem Statement

Your company runs applications on Amazon EKS with no centralized logging.

Current Problems:

- Logs are scattered across hundreds of pods — `kubectl logs` is not scalable
- Pods restart and lose their logs permanently
- No way to search across services or correlate errors
- Debugging a production incident requires manual log hunting

Build a centralized logging platform on EKS using the ELK Stack (Elasticsearch, Logstash, Kibana + Filebeat).

---

## Architecture

```
Every Pod on EKS
      │  (stdout/stderr logs)
      ▼
Filebeat (DaemonSet — 1 per node)
Reads: /var/log/containers/*.log
      │
      ▼
Logstash
(Parses, filters, enriches logs)
      │
      ▼
Elasticsearch
(Indexes and stores all logs)
      │
      ▼
Kibana (port-forward → localhost:5601)
(Search, filter, dashboard)

All resources in namespace: logging
```

---

## Project Structure

```
18-eks-elk-logging/
├── README.md
└── Resume-Points.md
    (No YAML files needed — everything deployed via Helm)
```

---

## Prerequisites

- Amazon EKS cluster running and kubectl configured (from Project 15)
- Helm installed → [Install Helm](https://helm.sh/docs/intro/install/)
- ⚠️ Minimum worker node size: **t3.medium** (ELK is memory-intensive — 4GB+ RAM per node recommended)

Verify:

```bash
kubectl get nodes
helm version
```

---

## Step 1 - Configure kubectl for EKS

```bash
aws eks update-kubeconfig --region ap-south-1 --name devops-cluster
```

---

## Step 2 - Create Logging Namespace

```bash
kubectl create namespace logging
```

---

## Step 3 - Add Elastic Helm Repository

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

Verify:

```bash
helm repo list | grep elastic
```

---

## Step 4 - Install Elasticsearch

```bash
helm install elasticsearch elastic/elasticsearch \
  --namespace logging \
  --set replicas=1 \
  --set resources.requests.memory=1Gi \
  --set resources.limits.memory=2Gi \
  --set persistence.enabled=false
```

> ℹ️ `replicas=1` and `persistence.enabled=false` are for demo purposes. Production requires 3 replicas with EBS PVCs.

Wait for Elasticsearch to be ready (~3 minutes):

```bash
kubectl get pods -n logging -w
```

Expected:

```
NAME                     READY   STATUS    RESTARTS
elasticsearch-master-0   1/1     Running   0
```

---

## Step 5 - Install Kibana

```bash
helm install kibana elastic/kibana \
  --namespace logging \
  --set elasticsearchHosts=http://elasticsearch-master:9200
```

Wait for Kibana to be ready:

```bash
kubectl get pods -n logging -l app=kibana
```

Expected:

```
NAME                    READY   STATUS
kibana-xxxxxxxxx-xxxxx  1/1     Running
```

---

## Step 6 - Install Logstash

```bash
helm install logstash elastic/logstash \
  --namespace logging \
  --set resources.requests.memory=512Mi \
  --set resources.limits.memory=1Gi
```

---

## Step 7 - Install Filebeat

```bash
helm install filebeat elastic/filebeat \
  --namespace logging \
  --set daemonset.hostNetworking=true
```

Verify Filebeat DaemonSet is running on every node:

```bash
kubectl get daemonset -n logging
```

Expected:

```
NAME       DESIRED   CURRENT   READY
filebeat   2         2         2      ← one per worker node
```

---

## Step 8 - Verify All Logging Pods

```bash
kubectl get pods -n logging
```

Expected:

```
NAME                          READY   STATUS
elasticsearch-master-0        1/1     Running
kibana-xxxxxxxxx-xxxxx        1/1     Running
logstash-xxxxxxxxx-xxxxx      1/1     Running
filebeat-xxxxx                1/1     Running  ← node 1
filebeat-yyyyy                1/1     Running  ← node 2
```

---

## Step 9 - Access Kibana

```bash
kubectl port-forward service/kibana-kibana 5601:5601 -n logging
```

Open: `http://localhost:5601`

---

## Step 10 - Create an Index Pattern in Kibana

1. Click **Stack Management** (gear icon)
2. Click **Index Patterns** → **Create index pattern**
3. Pattern: `filebeat-*`
4. Time field: `@timestamp`
5. Click **Create index pattern**

---

## Step 11 - Deploy a Sample Application and Generate Logs

```bash
kubectl create deployment nginx --image=nginx:1.27 --replicas=3
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Generate some log traffic
kubectl get svc nginx -w   # wait for EXTERNAL-IP
curl http://EXTERNAL-IP
curl http://EXTERNAL-IP/nonexistent  # generates 404 log entry
```

---

## Step 12 - Search Logs in Kibana

1. Click **Discover** in the left sidebar
2. Select index pattern: `filebeat-*`
3. Search for nginx logs:

```
kubernetes.labels.app: nginx
```

4. Filter for error logs:

```
log.level: error OR http.response.status_code: 404
```

Expected — nginx access logs visible with timestamps, pod names, and namespace.

---

## Step 13 - Create a Kibana Dashboard

1. Click **Dashboard** → **Create Dashboard**
2. Click **Add panel** → **Aggregation based** → **Vertical Bar**
3. Add visualisations for:
   - Log volume over time (by namespace)
   - Error count (4xx, 5xx responses)
   - Pod log activity (by pod name)
4. Save as: `EKS Application Logs`

---

## Verification Checklist

✅ Elasticsearch `Running` — 1 replica for demo

✅ Logstash `Running`

✅ Kibana `Running` — accessible at `localhost:5601`

✅ Filebeat DaemonSet — 1 pod per EKS worker node

✅ `filebeat-*` index pattern created in Kibana

✅ Logs visible in Discover view

✅ Nginx pod logs searchable by pod name and namespace

✅ Dashboard created with log volume panel

---

## Troubleshooting

**Elasticsearch pod `Pending` or `OOMKilled`:**
- Insufficient memory. ELK needs at least t3.medium nodes
- Check: `kubectl describe pod elasticsearch-master-0 -n logging`
- Reduce memory: `--set resources.limits.memory=1Gi`

**Kibana shows "Kibana server is not ready yet":**
- Kibana waits for Elasticsearch to be ready. Check Elasticsearch first:
  ```bash
  kubectl logs elasticsearch-master-0 -n logging | tail -20
  ```

**No logs in Kibana Discover:**
- Verify Filebeat is running on all nodes: `kubectl get daemonset -n logging`
- Check Filebeat logs: `kubectl logs daemonset/filebeat -n logging | tail -30`
- Ensure index pattern is `filebeat-*` not a specific date

---

## Cleanup

```bash
helm uninstall filebeat -n logging
helm uninstall logstash -n logging
helm uninstall kibana -n logging
helm uninstall elasticsearch -n logging
kubectl delete namespace logging
```

---

## Production Notes

> **1. Use 3-Node Elasticsearch Cluster with EBS PVCs**
> ```bash
> helm install elasticsearch elastic/elasticsearch \
>   --set replicas=3 \
>   --set persistence.enabled=true \
>   --set volumeClaimTemplate.resources.requests.storage=30Gi \
>   --set volumeClaimTemplate.storageClassName=gp2
> ```

> **2. Use Amazon OpenSearch Service Instead of Self-Hosted**
> Replace Elasticsearch + Kibana with Amazon OpenSearch Service — managed, HA, auto-backups, and integrates natively with AWS services including CloudWatch and Kinesis.

> **3. Use Fluent Bit Instead of Filebeat for EKS**
> Fluent Bit has lower memory overhead than Filebeat and is the AWS-recommended log shipper for EKS. AWS publishes an official Fluent Bit DaemonSet for EKS: `aws/aws-for-fluent-bit`.

> **4. Set Log Retention Policies**
> Configure Elasticsearch Index Lifecycle Management (ILM) to automatically delete logs older than 30 days to manage storage costs.

---

## Key Learnings

- ELK Stack on Amazon EKS (Elasticsearch, Logstash, Kibana, Filebeat)
- Filebeat DaemonSet (one pod per node — reads all container logs)
- Elastic Helm charts with resource limit overrides
- Kibana index patterns (`filebeat-*`) and time-field configuration
- Kibana Discover (log search and filtering with KQL)
- Kibana Dashboard creation (visualisations and panels)
- Elasticsearch replicas and PVC persistence
- KQL (Kibana Query Language) log filtering
- Fluent Bit as lightweight Filebeat alternative for EKS
- Amazon OpenSearch Service (managed ELK alternative)
- Index Lifecycle Management (ILM) for log retention
- `aws/aws-for-fluent-bit` DaemonSet (AWS-native logging)
