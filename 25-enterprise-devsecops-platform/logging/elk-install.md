# ELK Stack Installation on EKS

## Add Elastic Helm Repository

```bash
helm repo add elastic https://helm.elastic.co
helm repo update

kubectl create namespace logging
```

## Install Elasticsearch

```bash
helm install elasticsearch elastic/elasticsearch \
  --namespace logging \
  --set replicas=1 \
  --set resources.requests.memory=1Gi \
  --set resources.limits.memory=2Gi \
  --set persistence.enabled=true \
  --set volumeClaimTemplate.resources.requests.storage=10Gi \
  --set volumeClaimTemplate.storageClassName=gp2
```

## Install Kibana

```bash
helm install kibana elastic/kibana \
  --namespace logging \
  --set elasticsearchHosts=http://elasticsearch-master:9200
```

## Install Filebeat (DaemonSet — 1 pod per node)

```bash
helm install filebeat elastic/filebeat \
  --namespace logging \
  --set daemonset.hostNetworking=true
```

## Verify All Pods

```bash
kubectl get pods -n logging
```

Expected:
```
elasticsearch-master-0     1/1   Running
kibana-xxx                 1/1   Running
filebeat-xxx               1/1   Running   (one per worker node)
```

## Access Kibana

```bash
kubectl port-forward service/kibana-kibana 5601:5601 -n logging
```

Open: http://localhost:5601

## Create Index Pattern

1. Stack Management → Index Patterns → Create index pattern
2. Pattern: `filebeat-*`
3. Time field: `@timestamp`
4. Save

## Production Notes

> Use AWS Fluent Bit (`aws/aws-for-fluent-bit`) DaemonSet + Amazon OpenSearch Service for a managed, HA logging platform with native AWS integration.
