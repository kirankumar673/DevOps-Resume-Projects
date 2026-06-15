# Project 09 - Monitor Kubernetes Cluster Using Prometheus and Grafana

## Problem Statement

Your company has deployed applications on Kubernetes with no visibility into cluster health.

Current Problems:

- No visibility into CPU or memory usage
- No alerts when pods crash or nodes are under pressure
- No dashboards for operations teams
- No way to detect performance degradation before it causes outages

Build a monitoring solution using Prometheus and Grafana deployed via Helm.

---

## Architecture

```
Kubernetes Cluster
       │
       ├── Node Exporter (DaemonSet)     ← Collects node-level metrics (CPU, memory, disk)
       ├── kube-state-metrics            ← Collects pod/deployment/service state metrics
       │
       ▼
Prometheus Server
(Scrapes and stores metrics)
       │
       ▼
Grafana
(Visualises metrics as dashboards)
       │
       ▼
Browser → http://localhost:3000

All resources in namespace: monitoring
```

---

## Project Structure

```
09-kubernetes-monitoring/
├── README.md
└── Resume-Points.md
    (No YAML files needed — everything deployed via Helm)
```

---

## Prerequisites

- Minikube installed → [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- kubectl installed → [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- Helm installed → [Install Helm](https://helm.sh/docs/intro/install/)

Verify all tools:

```bash
minikube version
kubectl version --client
helm version
```

---

## Step 1 - Start Minikube

```bash
minikube start
```

Verify the cluster is ready:

```bash
kubectl get nodes
```

Expected:

```
NAME       STATUS   ROLES           AGE
minikube   Ready    control-plane   30s
```

---

## Step 2 - Create Monitoring Namespace

```bash
kubectl create namespace monitoring
```

Verify:

```bash
kubectl get namespaces | grep monitoring
```

Expected:

```
monitoring   Active   5s
```

---

## Step 3 - Add Helm Repositories

Add the Prometheus community Helm chart repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Verify:

```bash
helm repo list
```

Expected:

```
NAME                    URL
prometheus-community    https://prometheus-community.github.io/helm-charts
```

---

## Step 4 - Install kube-prometheus-stack

> ℹ️ We use `kube-prometheus-stack` — the official combined chart that installs **Prometheus + Grafana + Node Exporter + kube-state-metrics + Alertmanager** together. This is the production standard approach.

```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin123
```

Wait for all pods to be ready (this may take 2-3 minutes):

```bash
kubectl get pods -n monitoring -w
```

Expected — all pods `Running`:

```
NAME                                                   READY   STATUS
monitoring-grafana-xxxxxxxxx-xxxxx                     3/3     Running
monitoring-kube-prometheus-prometheus-0                2/2     Running
monitoring-kube-state-metrics-xxxxxxxxx-xxxxx          1/1     Running
monitoring-prometheus-node-exporter-xxxxx              1/1     Running
```

---

## Step 5 - Verify All Monitoring Components

```bash
kubectl get all -n monitoring
```

Check services specifically:

```bash
kubectl get svc -n monitoring
```

Expected services:

```
NAME                                      TYPE        CLUSTER-IP     PORT(S)
monitoring-grafana                        ClusterIP   10.96.xx.xx    80/TCP
monitoring-kube-prometheus-prometheus     ClusterIP   10.96.xx.xx    9090/TCP
monitoring-prometheus-node-exporter       ClusterIP   10.96.xx.xx    9100/TCP
```

---

## Step 6 - Access Prometheus UI

Forward the Prometheus port to your local machine:

```bash
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090
```

Open in browser:

```
http://localhost:9090
```

Try a sample PromQL query — in the Expression field enter:

```
up
```

Expected — shows all scrape targets and their status (1 = up, 0 = down).

---

## Step 7 - Access Grafana Dashboard

Open a **new terminal** (keep the Prometheus port-forward running) and run:

```bash
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```

Open in browser:

```
http://localhost:3000
```

Login with:

| Field | Value |
|-------|-------|
| Username | `admin` |
| Password | `admin123` |

---

## Step 8 - Import the Node Exporter Dashboard

1. In Grafana, click the **+** icon in the left sidebar
2. Click **Import**
3. Enter Dashboard ID: **`1860`** (Node Exporter Full — the most popular K8s dashboard)
4. Click **Load**
5. Select **Prometheus** as the data source
6. Click **Import**

Expected — a full dashboard appears showing:

```
CPU Usage      Memory Usage
Disk I/O       Network Traffic
Pod Count      Node Health
```

---

## Step 9 - Generate Load to Observe Metrics

In a new terminal, run a load-generating pod:

```bash
kubectl run load-test --image=nginx -n monitoring
```

Wait for it to start:

```bash
kubectl get pods -n monitoring -l run=load-test
```

Observe the CPU and Memory panels in Grafana updating in real time.

---

## Step 10 - Explore PromQL Queries

In the Prometheus UI (`http://localhost:9090`), try these queries:

```promql
# CPU usage across all nodes
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Running pods count
count(kube_pod_info)

# Pods not running
count(kube_pod_status_phase{phase!="Running"})
```

---

## Verification Checklist

✅ Minikube running with `monitoring` namespace created

✅ `kube-prometheus-stack` Helm chart installed successfully

✅ All pods in `monitoring` namespace are `Running`

✅ Prometheus UI accessible at `http://localhost:9090`

✅ `up` query in Prometheus shows all targets

✅ Grafana accessible at `http://localhost:3000`

✅ Dashboard 1860 imported and showing metrics

✅ CPU, memory, pod count metrics visible

---

## Troubleshooting

**Pods stuck in `Pending`:**
```bash
kubectl describe pod <POD_NAME> -n monitoring
```
Minikube may need more resources. Restart with more memory:
```bash
minikube stop
minikube start --memory=4096 --cpus=2
```

**Grafana shows "No data":**
- Confirm Prometheus is selected as the data source in the dashboard
- Go to: Connections → Data Sources → Prometheus → Test

**Port-forward drops:**
Port-forwards disconnect if idle. Re-run the `kubectl port-forward` command.

---

## Cleanup

```bash
helm uninstall monitoring -n monitoring
kubectl delete namespace monitoring
minikube stop
```

---

## Production Notes

> **1. Use Persistent Storage for Prometheus**
> By default, Prometheus data is lost when the pod restarts. In production, configure a `PersistentVolumeClaim`:
> ```bash
> helm install monitoring prometheus-community/kube-prometheus-stack \
>   --namespace monitoring \
>   --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=10Gi
> ```

> **2. Configure Alertmanager**
> `kube-prometheus-stack` includes Alertmanager. Configure it to send alerts to Slack, PagerDuty, or email when CPU > 80%, pods are crashing, or nodes are unreachable.

> **3. Use Grafana Cloud for Production Dashboards**
> Instead of self-hosting Grafana, use [Grafana Cloud](https://grafana.com/products/cloud/) (free tier available) with remote write from Prometheus.

> **4. Set Resource Requests/Limits on Prometheus**
> Prometheus is memory-intensive. Always set resource limits in production.

---

## Key Learnings

- Helm (package manager for Kubernetes)
- `kube-prometheus-stack` (Prometheus + Grafana + Node Exporter + Alertmanager)
- Kubernetes Namespaces for monitoring isolation
- Prometheus metrics scraping (Node Exporter, kube-state-metrics)
- PromQL queries (rate, avg, count, label filtering)
- Grafana dashboard import (Dashboard ID 1860)
- `kubectl port-forward` for local service access
- Alertmanager for production alerting
- PersistentVolumeClaims for metrics storage
