# Project 17 - Monitor Amazon EKS Using Prometheus and Grafana

## Problem Statement

Your company runs production workloads on Amazon EKS with no observability.

Current Problems:

- No visibility into node CPU or memory pressure
- No dashboards for the operations team
- No alerting when pods crash or nodes are unhealthy
- Can't correlate application issues with cluster resource usage

Build a production monitoring platform on EKS using the `kube-prometheus-stack` Helm chart.

---

## Architecture

```
Amazon EKS Cluster
       │
       ├── Node Exporter (DaemonSet — 1 per node)
       │     └── Collects: CPU, memory, disk, network per node
       ├── kube-state-metrics
       │     └── Collects: pod/deployment/node state metrics
       │
       ▼
Prometheus Server
(Stores metrics with time-series database)
       │
       ▼
Grafana
(Visualises metrics — dashboards, alerts)
       │
       ▼ kubectl port-forward
Browser → http://localhost:3000

All resources in namespace: monitoring
```

---

## Project Structure

```
17-eks-monitoring/
├── README.md
└── Resume-Points.md
    (No YAML files needed — everything deployed via Helm)
```

---

## Prerequisites

- Amazon EKS cluster running and kubectl configured (from Project 15)
- Helm installed → [Install Helm](https://helm.sh/docs/intro/install/)

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

Verify nodes are ready:

```bash
kubectl get nodes
```

Expected:

```
NAME                                       STATUS   ROLES    AGE
ip-10-0-3-xx.ap-south-1.compute.internal  Ready    <none>   10m
ip-10-0-4-xx.ap-south-1.compute.internal  Ready    <none>   10m
```

---

## Step 2 - Create Monitoring Namespace

```bash
kubectl create namespace monitoring
```

---

## Step 3 - Add the Prometheus Community Helm Repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Verify:

```bash
helm repo list
```

---

## Step 4 - Install kube-prometheus-stack

> ℹ️ `kube-prometheus-stack` is the production-standard chart — it installs Prometheus, Grafana, Node Exporter, kube-state-metrics, and Alertmanager in one command.

```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin123 \
  --set prometheus.prometheusSpec.retention=7d
```

Wait for all pods to be ready (2–3 minutes):

```bash
kubectl get pods -n monitoring -w
```

Expected:

```
NAME                                                   READY   STATUS
monitoring-grafana-xxxxxxxxx-xxxxx                     3/3     Running
monitoring-kube-prometheus-prometheus-0                2/2     Running
monitoring-kube-state-metrics-xxxxxxxxx-xxxxx          1/1     Running
monitoring-prometheus-node-exporter-xxxxx              1/1     Running  ← one per node
monitoring-prometheus-node-exporter-yyyyy              1/1     Running  ← one per node
```

---

## Step 5 - Verify All Monitoring Services

```bash
kubectl get svc -n monitoring
```

Expected:

```
NAME                                          TYPE        PORT(S)
monitoring-grafana                            ClusterIP   80/TCP
monitoring-kube-prometheus-prometheus         ClusterIP   9090/TCP
monitoring-prometheus-node-exporter           ClusterIP   9100/TCP
```

---

## Step 6 - Access Prometheus UI

```bash
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090
```

Open: `http://localhost:9090`

Run a test PromQL query:

```promql
up
```

Expected — all scrape targets showing `1` (up).

---

## Step 7 - Access Grafana

Open a **new terminal** and run:

```bash
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```

Open: `http://localhost:3000`

Login:

| Field | Value |
|-------|-------|
| Username | `admin` |
| Password | `admin123` |

---

## Step 8 - Import Node Exporter Dashboard

1. Click **+** → **Import**
2. Enter Dashboard ID: **`1860`** (Node Exporter Full)
3. Click **Load**
4. Select **Prometheus** as data source
5. Click **Import**

Expected — dashboard shows real EKS node metrics:

```
CPU Usage per Node
Memory Usage per Node
Disk I/O
Network Traffic
Pod Count
```

---

## Step 9 - Write PromQL Queries for EKS

In Prometheus UI (`http://localhost:9090`), try:

```promql
# CPU usage rate per node
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory available
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Count running pods across all namespaces
count(kube_pod_info{pod_phase="Running"})

# Pods NOT in Running state (alerts candidate)
count(kube_pod_status_phase{phase!="Running"})

# Node disk pressure
kube_node_status_condition{condition="DiskPressure", status="true"}
```

---

## Step 10 - Deploy a Sample Application and Observe

Deploy a workload to generate metrics:

```bash
kubectl create deployment nginx --image=nginx:1.27 --replicas=5
```

Watch the pod count metric update in Grafana in real time.

---

## Verification Checklist

✅ EKS nodes `Ready`

✅ `kube-prometheus-stack` installed — all pods `Running`

✅ One Node Exporter pod per worker node (DaemonSet)

✅ Prometheus UI accessible — `up` query shows all targets

✅ Grafana accessible at `http://localhost:3000`

✅ Dashboard 1860 imported — showing real node metrics

✅ CPU, memory, disk, network metrics visible per EKS node

---

## Troubleshooting

**Node Exporter only shows 1 pod (expected 2):**
- Node Exporter is a DaemonSet — one pod per node. Check: `kubectl get daemonset -n monitoring`

**Grafana "No data" on dashboard panels:**
- Confirm Prometheus is the data source: Connections → Data Sources → Prometheus → Test
- Check Prometheus URL: `http://monitoring-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090`

**Port-forward disconnects:**
- This is normal for idle connections. Re-run the `kubectl port-forward` command.

---

## Cleanup

```bash
helm uninstall monitoring -n monitoring
kubectl delete namespace monitoring
```

---

## Production Notes

> **1. Use Persistent Storage for Prometheus on EKS**
> By default, metrics are lost when Prometheus restarts. Add an EBS-backed PVC:
> ```bash
> helm install monitoring prometheus-community/kube-prometheus-stack \
>   --namespace monitoring \
>   --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=gp2 \
>   --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=20Gi
> ```

> **2. Configure Alertmanager for EKS Alerts**
> Create PrometheusRule resources for: node CPU > 80%, pod CrashLoopBackOff, disk pressure, and memory pressure. Route alerts to Slack or PagerDuty via Alertmanager.

> **3. Use Amazon Managed Prometheus (AMP) for Production**
> Replace self-hosted Prometheus with Amazon Managed Prometheus — no capacity planning, HA built-in, and integrates with Amazon Managed Grafana.

---

## Key Learnings

- `kube-prometheus-stack` on Amazon EKS
- Node Exporter DaemonSet (one pod per node)
- kube-state-metrics (Kubernetes object state)
- PromQL queries for EKS cluster health
- Prometheus retention configuration (`--set prometheus.prometheusSpec.retention=7d`)
- Grafana Dashboard 1860 (Node Exporter Full)
- `kubectl port-forward` for accessing cluster-internal services
- EBS-backed PersistentVolumeClaims for Prometheus on EKS
- PrometheusRule CRDs for alert configuration
- Alertmanager (Slack/PagerDuty integration)
- Amazon Managed Prometheus + Grafana (production alternative)
