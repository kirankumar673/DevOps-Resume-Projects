# Resume Points — Project 18: EKS Centralized Logging with ELK Stack

---

## Fresher

- Deployed a full ELK Stack on Amazon EKS using Helm: Elasticsearch, Logstash, Kibana, and Filebeat — all in a dedicated `logging` namespace.
- Verified that Filebeat runs as a DaemonSet — one pod per worker node — reading all container logs from `/var/log/containers/` and shipping them to Elasticsearch.
- Created a `filebeat-*` index pattern in Kibana and used Kibana Discover to search and filter nginx pod logs using KQL (Kibana Query Language).
- Built a Kibana dashboard with log volume over time, error count, and per-pod activity panels for operational visibility.

---

## Experienced DevOps Engineer

- Deployed ELK Stack on EKS with memory-optimised Helm values — Elasticsearch `--set resources.limits.memory=2Gi` and Logstash `--set resources.limits.memory=1Gi` to prevent OOMKilled pods on t3.medium nodes.
- Configured Kibana to connect to Elasticsearch via the in-cluster DNS name (`http://elasticsearch-master:9200`) and created index patterns, KQL filters, and dashboard visualisations for multi-service log analysis.
- Articulated the operational trade-offs of self-hosted ELK vs Amazon OpenSearch Service (managed, HA, auto-backups) and Filebeat vs Fluent Bit (lower overhead, AWS-native `aws-for-fluent-bit` DaemonSet).
- Documented production upgrade paths: 3-replica Elasticsearch with EBS-backed PVCs, Index Lifecycle Management for 30-day log retention, and Amazon OpenSearch Service for managed operations.

---

## LinkedIn Project Description

Deployed centralized logging on Amazon EKS using the ELK Stack (Elasticsearch, Logstash, Kibana, Filebeat) via Elastic Helm charts in a dedicated `logging` namespace. Configured Filebeat as a DaemonSet collecting logs from all container pods, Kibana index patterns with KQL search, and dashboard visualisations for log volume and error tracking. Applied memory-optimised Helm values to prevent OOMKilled pods. Documented 3-replica Elasticsearch with EBS PVC persistence, ILM log retention, and Amazon OpenSearch + Fluent Bit as production alternatives.

---

## GitHub Project Description

EKS ELK Stack Logging — Helm-deployed Elasticsearch, Logstash, Kibana, Filebeat DaemonSet on Amazon EKS. Kibana `filebeat-*` index pattern, KQL log search, dashboard creation. Memory-optimised values, troubleshooting guide, and documented Amazon OpenSearch + Fluent Bit production upgrade paths.

---

## How to Explain in an Interview (30 Seconds)

"I deployed centralized logging on Amazon EKS using the ELK Stack. The key component is Filebeat — it runs as a DaemonSet so there's one pod on every worker node, and it reads all container logs from the node's filesystem and ships them to Elasticsearch. I configured Kibana with a `filebeat-*` index pattern so the team can search across all pods, filter by namespace, and find errors without SSH-ing into nodes or running `kubectl logs`. In production, I'd replace Filebeat with AWS Fluent Bit — it uses less memory — and use Amazon OpenSearch Service instead of self-hosted Elasticsearch so we don't have to manage cluster scaling and backups."

---

## Skills Demonstrated

- ELK Stack on Amazon EKS (Elasticsearch, Logstash, Kibana, Filebeat)
- Elastic Helm charts with memory-optimised value overrides
- Filebeat DaemonSet (per-node container log collection)
- Kibana index patterns (`filebeat-*`, `@timestamp` field)
- KQL (Kibana Query Language) log search and filtering
- Kibana Dashboard and visualisation creation
- Elasticsearch in-cluster DNS service discovery
- Memory resource limits for ELK on Kubernetes (OOMKilled prevention)
- Elasticsearch replicas and EBS PVC persistence (production)
- Index Lifecycle Management (ILM — log retention policies)
- Fluent Bit vs Filebeat (memory overhead trade-offs)
- `aws/aws-for-fluent-bit` DaemonSet (AWS-native EKS logging)
- Amazon OpenSearch Service (managed ELK alternative)
- Troubleshooting OOMKilled and pending ELK pods
