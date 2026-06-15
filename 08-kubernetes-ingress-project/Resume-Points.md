# Resume Points — Project 08: Kubernetes Ingress

---

## Fresher

- Configured a Kubernetes Ingress resource to expose two applications through a single IP address using path-based routing (`/app1`, `/app2`).
- Enabled the Nginx Ingress Controller on Minikube using `minikube addons enable ingress`.
- Used `ingressClassName: nginx` to target the correct Ingress Controller as required by modern Kubernetes versions.
- Added the `rewrite-target: /` annotation to strip URL path prefixes before forwarding requests to backend services.

---

## Experienced DevOps Engineer

- Designed a Kubernetes Ingress-based traffic routing solution replacing per-application NodePorts with a single centralised entry point — reducing port management complexity across multiple services.
- Configured the Nginx Ingress Controller with `ingressClassName: nginx`, `nginx.ingress.kubernetes.io/rewrite-target: /` annotation, and host-based routing (`demo.local`) for precise traffic control.
- Applied namespace isolation (`ingress-demo`) across all Ingress, Deployment, and Service resources to maintain clean cluster organisation.
- Pinned `hashicorp/http-echo` images to version `0.2.3` and added CPU/memory resource limits on both application deployments.
- Documented production upgrade path using TLS with cert-manager (Let's Encrypt), real domain configuration, and rate-limiting annotations.

---

## LinkedIn Project Description

Implemented Kubernetes Ingress-based path routing to expose two applications (`/app1`, `/app2`) through a single IP with the Nginx Ingress Controller. Configured `ingressClassName: nginx`, `rewrite-target` annotation for path stripping, host-based routing, namespace isolation, pinned image versions, and resource limits on all deployments. Added local `/etc/hosts` DNS entry for Minikube testing and documented a production TLS upgrade path using cert-manager and Let's Encrypt.

---

## GitHub Project Description

Kubernetes Ingress Project — Path-based routing via Nginx Ingress Controller with `ingressClassName: nginx`, `rewrite-target` annotation, host routing, namespace isolation, pinned image versions, and resource limits. Includes `/etc/hosts` setup for local DNS testing and documented cert-manager TLS upgrade path.

---

## How to Explain in an Interview (30 Seconds)

"I deployed two applications on Kubernetes and exposed them through a single Ingress resource using path-based routing — `/app1` and `/app2`. I enabled the Nginx Ingress Controller on Minikube and configured `ingressClassName: nginx`, which is required for modern Kubernetes. I also added the `rewrite-target: /` annotation — without it, the backend receives `/app1` as the path and returns a 404 because it only listens on `/`. For local testing, I added the Minikube IP to `/etc/hosts` as `demo.local`. In production, you'd replace that with a real domain and add TLS using cert-manager."

---

## Skills Demonstrated

- Kubernetes Ingress (resource configuration, path routing)
- Nginx Ingress Controller (installation via Minikube addon)
- `ingressClassName: nginx` (modern controller targeting)
- `nginx.ingress.kubernetes.io/rewrite-target` annotation (path prefix stripping)
- Host-based routing (`host:` field in Ingress rules)
- Path-based routing (`Prefix` pathType)
- Kubernetes Namespace isolation (all resources scoped to `ingress-demo`)
- Kubernetes Deployments with resource requests/limits
- Kubernetes ClusterIP Services (internal backend exposure)
- Pinned Docker image versions (reproducible deployments)
- `/etc/hosts` DNS configuration for local Minikube testing
- TLS with cert-manager and Let's Encrypt (production upgrade path)
- Rate limiting with Nginx Ingress annotations (production hardening)
- Troubleshooting Ingress (404 routing, 503 backend unavailable, missing ADDRESS)
