# Resume Points — Project 07: Kubernetes Voting App

---

## Fresher

- Deployed a five-component distributed voting application (Vote, Redis, Worker, PostgreSQL, Result) on Kubernetes.
- Created a dedicated Kubernetes Namespace (`voting-app`) to isolate all application components.
- Stored PostgreSQL credentials securely using a Kubernetes `Secret` with `secretKeyRef` — never hardcoded in deployment manifests.
- Configured `livenessProbe` and `readinessProbe` on all services to enable automated health management.

---

## Experienced DevOps Engineer

- Designed and deployed a production-aligned multi-tier Kubernetes application with five services communicating via Kubernetes ClusterIP service discovery — Vote App → Redis → Worker → PostgreSQL → Result App.
- Implemented Kubernetes Secrets (`secretKeyRef`) to inject PostgreSQL credentials into containers at runtime, replacing the insecure pattern of hardcoding values in deployment YAML.
- Applied resource `requests` and `limits` on all five deployments to ensure fair cluster resource allocation and prevent noisy-neighbour issues.
- Pinned Redis to a versioned image (`redis:7`) and added a `livenessProbe` using `redis-cli ping` to detect and recover from Redis failures automatically.
- Configured `readinessProbe` using `pg_isready` on PostgreSQL to prevent worker connections before the database is fully initialised.

---

## LinkedIn Project Description

Deployed a five-tier distributed voting application on Kubernetes (Vote → Redis → Worker → PostgreSQL → Result). Implemented Kubernetes Secrets for secure credential management using `secretKeyRef`, resource requests/limits on all deployments, health probes (`livenessProbe` with `redis-cli ping` for Redis, `readinessProbe` with `pg_isready` for PostgreSQL), namespace isolation, and pinned image versions. Demonstrates real-world multi-service Kubernetes architecture with production security and reliability patterns.

---

## GitHub Project Description

Kubernetes Voting App — Five-service distributed application (Vote, Redis, Worker, PostgreSQL, Result) with namespace isolation, Kubernetes Secrets for credential management (`secretKeyRef`), resource requests/limits on all deployments, service-specific health probes, and pinned image versions. Production-aligned multi-tier Kubernetes architecture.

---

## How to Explain in an Interview (30 Seconds)

"I deployed a multi-tier voting app on Kubernetes with five components — a vote frontend, Redis queue, worker process, PostgreSQL database, and result frontend. The key production aspect was security: I stored PostgreSQL credentials in a Kubernetes Secret and referenced them with `secretKeyRef` — never hardcoded. I also set resource limits on all deployments, added a `livenessProbe` on Redis using `redis-cli ping`, and a `readinessProbe` on PostgreSQL using `pg_isready` to ensure the worker only connects after the database is ready."

---

## Skills Demonstrated

- Kubernetes multi-tier architecture (5-service application)
- Kubernetes Namespaces (workload isolation)
- Kubernetes Secrets (`secretKeyRef`, `stringData`)
- Secure credential management (vs hardcoded `value:` in manifests)
- Kubernetes Deployments (multi-replica, rolling updates)
- Kubernetes Services (ClusterIP for internal, NodePort for external)
- Service discovery (inter-pod communication by service name)
- Resource requests and limits (CPU/memory on all workloads)
- `livenessProbe` with `exec` command (`redis-cli ping`)
- `readinessProbe` with `exec` command (`pg_isready`)
- Redis (in-memory queue, versioned image `redis:7`)
- PostgreSQL on Kubernetes
- `kubectl apply -f .` (bulk manifest deployment)
- `kubectl get all -n <namespace>` (full namespace overview)
- Troubleshooting with `kubectl describe` and `kubectl logs`
