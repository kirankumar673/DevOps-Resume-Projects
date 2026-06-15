# Resume Points — Project 17: EKS Monitoring with Prometheus & Grafana

---

## Fresher

- Deployed a full Kubernetes monitoring stack on Amazon EKS using the `kube-prometheus-stack` Helm chart with 7-day metrics retention.
- Verified that Node Exporter runs as a DaemonSet — one pod per worker node — automatically collecting CPU, memory, disk, and network metrics from each EKS node.
- Imported Grafana Dashboard 1860 (Node Exporter Full) and observed real-time EKS cluster metrics including per-node CPU and memory usage.
- Wrote PromQL queries for cluster health: CPU usage rate, memory availability, running pod count, non-running pod detection, and disk pressure conditions.

---

## Experienced DevOps Engineer

- Deployed `kube-prometheus-stack` on Amazon EKS with production configuration: 7-day Prometheus retention, dedicated `monitoring` namespace, and correct Prometheus data source URL for in-cluster service discovery.
- Wrote production-grade PromQL queries for EKS operational monitoring: CPU rate per node, memory availability percentage, pod phase distribution, and `kube_node_status_condition` for disk/memory pressure alerting.
- Distinguished between self-hosted Prometheus on EKS and Amazon Managed Prometheus (AMP) — documented when each is appropriate based on scale, HA requirements, and operational overhead.
- Documented EBS-backed PVC configuration for Prometheus data persistence on EKS and Alertmanager configuration for PrometheusRule-based alerts to Slack/PagerDuty.

---

## LinkedIn Project Description

Deployed a production monitoring platform on Amazon EKS using `kube-prometheus-stack` Helm chart with 7-day retention: Prometheus, Grafana, Node Exporter (DaemonSet per node), kube-state-metrics, and Alertmanager in the `monitoring` namespace. Wrote PromQL queries for CPU/memory usage, pod phase monitoring, and node condition alerting. Imported Grafana Dashboard 1860 showing real EKS node metrics. Documented EBS PVC for metrics persistence, PrometheusRule-based alerting, and Amazon Managed Prometheus as a production alternative.

---

## GitHub Project Description

EKS Monitoring — `kube-prometheus-stack` on Amazon EKS with 7-day retention, Node Exporter DaemonSet, PromQL queries for CPU/memory/pod health, Grafana Dashboard 1860, and documented EBS PVC + Alertmanager + Amazon Managed Prometheus production patterns.

---

## How to Explain in an Interview (30 Seconds)

"I deployed monitoring on Amazon EKS using the `kube-prometheus-stack` Helm chart — one command installs Prometheus, Grafana, Node Exporter, kube-state-metrics, and Alertmanager together. The key thing about Node Exporter on Kubernetes is it runs as a DaemonSet — so you automatically get one pod per node collecting metrics. I wrote PromQL queries to check CPU usage rates, memory availability, and pod health. For production, I documented adding an EBS-backed PVC for Prometheus data persistence — without it, you lose all your metrics history if Prometheus restarts."

---

## Skills Demonstrated

- `kube-prometheus-stack` on Amazon EKS
- Helm chart deployment with value overrides (`--set`)
- Node Exporter DaemonSet (per-node metrics collection)
- kube-state-metrics (Kubernetes object state metrics)
- PromQL (rate, avg, count, label filtering, conditions)
- Prometheus retention configuration
- Grafana Dashboard 1860 (Node Exporter Full)
- Prometheus in-cluster service discovery URL
- `kubectl port-forward` for cluster-internal access
- EBS-backed PVC for Prometheus metrics persistence
- PrometheusRule CRDs for Alertmanager alerting
- Alertmanager (Slack/PagerDuty integration)
- Amazon Managed Prometheus (AMP) — production alternative
- Amazon Managed Grafana — production alternative
