# Resume Points — Project 09: Kubernetes Monitoring with Prometheus & Grafana

---

## Fresher

- Deployed a full Kubernetes monitoring stack (Prometheus, Grafana, Node Exporter, Alertmanager) using the `kube-prometheus-stack` Helm chart.
- Created a dedicated `monitoring` namespace to isolate observability infrastructure from application workloads.
- Imported Grafana Dashboard ID 1860 (Node Exporter Full) to visualise real-time CPU, memory, disk, and network metrics.
- Used `kubectl port-forward` to securely access Prometheus and Grafana UIs without exposing them publicly.

---

## Experienced DevOps Engineer

- Deployed the `kube-prometheus-stack` Helm chart — the production-standard observability bundle that includes Prometheus, Grafana, Node Exporter (DaemonSet), kube-state-metrics, and Alertmanager in a single installation.
- Wrote PromQL queries to analyse cluster health: CPU usage rate, memory availability, running pod counts, and non-running pod detection.
- Configured Grafana with the Prometheus data source and imported pre-built dashboards for operational visibility.
- Documented production upgrade paths: PersistentVolumeClaims for metrics retention, Alertmanager configuration for Slack/PagerDuty alerts, and resource limits for Prometheus.

---

## LinkedIn Project Description

Implemented Kubernetes observability using the `kube-prometheus-stack` Helm chart, deploying Prometheus, Grafana, Node Exporter, kube-state-metrics, and Alertmanager into a dedicated `monitoring` namespace. Configured Grafana with Dashboard 1860 for real-time cluster metrics (CPU, memory, pod health). Wrote PromQL queries for CPU usage rates, memory availability, and pod status monitoring. Documented production patterns including persistent storage for metrics and Alertmanager notification configuration.

---

## GitHub Project Description

Kubernetes Monitoring Stack — `kube-prometheus-stack` Helm deployment with Prometheus metrics collection, Grafana Dashboard 1860 (Node Exporter Full), PromQL queries, dedicated namespace isolation, and documented production upgrade paths for alerting and storage persistence.

---

## How to Explain in an Interview (30 Seconds)

"I set up Kubernetes monitoring using the `kube-prometheus-stack` Helm chart — which is the standard way to deploy Prometheus, Grafana, Node Exporter, and Alertmanager together. I created a dedicated `monitoring` namespace, imported the Node Exporter dashboard in Grafana to see real-time CPU and memory metrics, and wrote PromQL queries to check cluster health. I also documented how to configure Alertmanager for Slack notifications and add persistent storage — which you'd need in production so you don't lose metrics data when pods restart."

---

## Skills Demonstrated

- Helm (Kubernetes package manager — `helm install`, `helm repo add`)
- `kube-prometheus-stack` (production monitoring bundle)
- Prometheus (metrics scraping, storage, PromQL)
- PromQL (rate, avg, count, label filtering queries)
- Grafana (dashboard import, data source configuration)
- Node Exporter (node-level metrics — CPU, memory, disk, network)
- kube-state-metrics (Kubernetes object state metrics)
- Alertmanager (alert routing — production upgrade path)
- Kubernetes Namespaces (monitoring isolation)
- `kubectl port-forward` (secure local service access)
- PersistentVolumeClaims for Prometheus (production upgrade path)
- Troubleshooting with `kubectl describe` and `kubectl logs`
