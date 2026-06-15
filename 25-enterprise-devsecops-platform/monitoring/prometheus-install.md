# Prometheus + Grafana Installation on EKS

## Install using kube-prometheus-stack (includes both)

```bash
# Add Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace
kubectl create namespace monitoring

# Install kube-prometheus-stack
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin123 \
  --set prometheus.prometheusSpec.retention=7d \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=gp2 \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=20Gi
```

## Verify

```bash
kubectl get pods -n monitoring
```

Expected:
```
monitoring-grafana-xxx                    3/3   Running
monitoring-kube-prometheus-prometheus-0   2/2   Running
monitoring-prometheus-node-exporter-xxx   1/1   Running   (one per node)
monitoring-kube-state-metrics-xxx         1/1   Running
```

## Access Prometheus

```bash
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090
```

Open: http://localhost:9090

### Useful PromQL queries

```promql
# CPU usage per node
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory available %
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Running pods
count(kube_pod_status_phase{phase="Running"})

# Pods NOT running (alert candidate)
count(kube_pod_status_phase{phase!="Running"})
```
