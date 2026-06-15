# Grafana Access and Dashboard Setup

## Access Grafana

```bash
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```

Open: http://localhost:3000

| Field    | Value    |
|----------|----------|
| Username | admin    |
| Password | admin123 |

## Import Node Exporter Dashboard

1. Click **+** → **Import**
2. Dashboard ID: **1860** (Node Exporter Full)
3. Select **Prometheus** as data source
4. Click **Import**

## Import Kubernetes Cluster Dashboard

1. Click **+** → **Import**
2. Dashboard ID: **315** (Kubernetes Cluster Monitoring)
3. Select **Prometheus** as data source
4. Click **Import**

## Create Application Dashboard

Add panels for:
- HTTP request rate: `rate(flask_http_request_total[5m])`
- Response time P95: `histogram_quantile(0.95, rate(flask_http_request_duration_seconds_bucket[5m]))`
- Error rate: `rate(flask_http_request_total{status=~"5.."}[5m])`

## Production Notes

> Use Amazon Managed Grafana for production — no infrastructure to manage, HA built-in, integrates with AWS IAM and Amazon Managed Prometheus.
