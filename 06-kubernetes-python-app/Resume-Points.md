# Resume Points — Project 06: Python App on Kubernetes

---

## Fresher

- Deployed a Dockerized Python Flask application on Kubernetes using a Deployment with 2 replicas for redundancy.
- Created a dedicated Kubernetes Namespace to isolate application resources from other cluster workloads.
- Configured `livenessProbe` and `readinessProbe` on the container so Kubernetes can detect and restart unhealthy pods.
- Demonstrated Kubernetes auto-healing by deleting a pod manually and observing automatic replacement.

---

## Experienced DevOps Engineer

- Deployed a containerized Python application on Kubernetes with production-grade manifests: dedicated namespace, resource `requests` and `limits` (CPU/memory), `livenessProbe`, `readinessProbe`, and multi-replica deployment for high availability.
- Configured resource requests and limits to prevent pods from consuming excessive cluster resources and enable proper scheduler placement.
- Implemented health probes against the `/health` HTTP endpoint, enabling Kubernetes to automatically restart failing containers and withhold traffic from pods not yet ready.
- Demonstrated horizontal scaling using `kubectl scale` and validated auto-healing by simulating pod failure.
- Used `eval $(minikube docker-env)` to build images directly inside Minikube's Docker daemon, enabling local Kubernetes image testing without a remote registry.

---

## LinkedIn Project Description

Deployed a Python Flask application on Kubernetes with production-grade manifests: dedicated namespace isolation, CPU/memory resource requests and limits, `livenessProbe` and `readinessProbe` against the `/health` endpoint, and multi-replica deployment. Demonstrated Kubernetes auto-healing (automatic pod replacement on failure) and horizontal scaling. Used Gunicorn as the WSGI server and configured `imagePullPolicy: Never` for local Minikube development with `eval $(minikube docker-env)`.

---

## GitHub Project Description

Kubernetes Python App — Production-grade deployment with namespace isolation, resource requests/limits, liveness and readiness probes, multi-replica setup, horizontal scaling, and auto-healing demonstration. Built with Gunicorn + Flask and deployed using Minikube with local image builds.

---

## How to Explain in an Interview (30 Seconds)

"I deployed a Python Flask app on Kubernetes with production-level manifests. I created a dedicated namespace to isolate resources, set CPU and memory requests and limits so the scheduler can place pods correctly, and added liveness and readiness probes hitting the `/health` endpoint. The liveness probe restarts the container if it becomes unhealthy, and the readiness probe ensures traffic only reaches pods that are fully ready. I also demonstrated auto-healing — deleted a pod manually and Kubernetes replaced it within seconds."

---

## Skills Demonstrated

- Kubernetes Namespaces (resource isolation)
- Kubernetes Deployments (ReplicaSet, rolling updates)
- Kubernetes Services (NodePort)
- Resource requests and limits (CPU/memory)
- `livenessProbe` (auto-restart unhealthy containers)
- `readinessProbe` (traffic gating for ready pods)
- Horizontal scaling (`kubectl scale`)
- Auto-healing demonstration (pod deletion and replacement)
- `kubectl` commands (`apply`, `get`, `describe`, `logs`, `scale`, `delete`)
- Minikube local development (`minikube start`, `minikube docker-env`)
- `imagePullPolicy: Never` (local image in Minikube)
- Gunicorn WSGI server in containers
- Namespace-scoped resource management
- Troubleshooting with `kubectl describe` and `kubectl logs`
