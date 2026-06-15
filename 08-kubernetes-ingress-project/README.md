# Project 08 - Expose Kubernetes Applications Using Ingress

## Problem Statement

Your company has deployed multiple applications on Kubernetes.

Current Problems:

- Each application requires its own NodePort on a random high port (e.g., 31234, 32456)
- Users need to remember different port numbers
- No clean URL routing (e.g., `/app1`, `/app2`)
- No centralized entry point — hard to add SSL later
- Not production-ready

Build a solution using Kubernetes Ingress to route traffic to multiple apps via a single IP and clean URL paths.

---

## Architecture

```
User (Browser)
      │
      ▼ Port 80 (single entry point)
┌─────────────────────┐
│  Nginx Ingress      │  ← Ingress Controller
│  Controller         │  (installed via minikube addon)
└─────────────────────┘
      │
      ├── /app1  ──────────────▶  app1-service  ──▶  App1 Pods
      │                           (ClusterIP:80)      (http-echo "Application 1")
      │
      └── /app2  ──────────────▶  app2-service  ──▶  App2 Pods
                                  (ClusterIP:80)      (http-echo "Application 2")

All resources in namespace: ingress-demo
```

---

## Project Structure

```
08-kubernetes-ingress-project/
├── namespace.yaml
├── app1-deployment.yaml
├── app1-service.yaml
├── app2-deployment.yaml
├── app2-service.yaml
└── ingress.yaml
```

---

## Prerequisites

- Minikube installed → [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- kubectl installed → [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

Verify:

```bash
minikube version
kubectl version --client
```

---

## Step 1 - Start Minikube

```bash
minikube start
```

Verify the cluster is ready:

```bash
kubectl get nodes
```

Expected:

```
NAME       STATUS   ROLES           AGE
minikube   Ready    control-plane   30s
```

---

## Step 2 - Enable the Nginx Ingress Addon

Minikube ships with a built-in Nginx Ingress Controller. Enable it:

```bash
minikube addons enable ingress
```

Wait for the ingress controller pod to be ready (this may take 1–2 minutes):

```bash
kubectl get pods -n ingress-nginx -w
```

Expected — wait until `Running`:

```
NAME                                        READY   STATUS    RESTARTS
ingress-nginx-controller-xxxxxxxxx-xxxxx    1/1     Running   0
```

---

## Step 3 - Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

Verify:

```bash
kubectl get namespaces | grep ingress-demo
```

Expected:

```
ingress-demo   Active   5s
```

---

## Step 4 - Deploy Application 1

Apply the deployment and service for App 1:

```bash
kubectl apply -f app1-deployment.yaml
kubectl apply -f app1-service.yaml
```

Verify App 1 pods are running:

```bash
kubectl get pods -n ingress-demo -l app=app1
```

Expected:

```
NAME                    READY   STATUS    RESTARTS
app1-xxxxxxxxx-xxxxx    1/1     Running   0
app1-xxxxxxxxx-yyyyy    1/1     Running   0
```

---

## Step 5 - Deploy Application 2

```bash
kubectl apply -f app2-deployment.yaml
kubectl apply -f app2-service.yaml
```

Verify App 2 pods are running:

```bash
kubectl get pods -n ingress-demo -l app=app2
```

Expected:

```
NAME                    READY   STATUS    RESTARTS
app2-xxxxxxxxx-xxxxx    1/1     Running   0
app2-xxxxxxxxx-yyyyy    1/1     Running   0
```

---

## Step 6 - Apply the Ingress Resource

Review the key parts of `ingress.yaml` before applying:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: ingress-demo
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /   # strips /app1 prefix before forwarding
spec:
  ingressClassName: nginx                            # required for modern ingress controller
  rules:
  - host: demo.local
    http:
      paths:
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 80
```

> ℹ️ Key points:
> - `ingressClassName: nginx` is required for the modern Nginx Ingress Controller
> - `rewrite-target: /` strips the `/app1` or `/app2` prefix before the request hits the backend
> - `host: demo.local` — we will map this in `/etc/hosts` in the next step

Apply:

```bash
kubectl apply -f ingress.yaml
```

Verify the Ingress was created:

```bash
kubectl get ingress -n ingress-demo
```

Expected:

```
NAME          CLASS   HOSTS        ADDRESS         PORTS   AGE
app-ingress   nginx   demo.local   192.168.49.2    80      10s
```

---

## Step 7 - Get the Minikube IP

```bash
minikube ip
```

Example output:

```
192.168.49.2
```

---

## Step 8 - Add Host Entry for Local Testing

Add the Minikube IP to your local `/etc/hosts` file so `demo.local` resolves correctly.

On **macOS/Linux**:

```bash
echo "$(minikube ip) demo.local" | sudo tee -a /etc/hosts
```

On **Windows** (run PowerShell as Administrator):

```powershell
Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "$(minikube ip) demo.local"
```

Verify:

```bash
ping demo.local
```

Expected:

```
PING demo.local (192.168.49.2)
```

---

## Step 9 - Test URL Routing

Test App 1:

```bash
curl http://demo.local/app1
```

Expected:

```
Application 1
```

Test App 2:

```bash
curl http://demo.local/app2
```

Expected:

```
Application 2
```

Or open both in your browser:

- `http://demo.local/app1` → Application 1
- `http://demo.local/app2` → Application 2

---

## Verification Checklist

✅ Minikube cluster running

✅ Nginx Ingress Controller pod is `Running` in `ingress-nginx` namespace

✅ Namespace `ingress-demo` created

✅ App1 pods (2 replicas) running

✅ App2 pods (2 replicas) running

✅ Ingress resource created with ADDRESS populated

✅ `/app1` returns `Application 1`

✅ `/app2` returns `Application 2`

---

## Troubleshooting

**Ingress ADDRESS is empty:**

Wait 1–2 minutes for the Ingress Controller to assign an IP. If still empty:

```bash
kubectl describe ingress app-ingress -n ingress-demo
```

**`curl` returns 404:**

Check that `rewrite-target: /` annotation is present in `ingress.yaml`. Without it, the backend receives `/app1` as the path and returns 404.

**`curl` returns 503:**

The backend pods may not be ready. Check:

```bash
kubectl get pods -n ingress-demo
kubectl get endpoints -n ingress-demo
```

---

## Cleanup

Remove all resources:

```bash
kubectl delete -f .
```

Or delete the entire namespace:

```bash
kubectl delete namespace ingress-demo
```

Stop Minikube:

```bash
minikube stop
```

Remove the `/etc/hosts` entry:

```bash
sudo sed -i '' '/demo.local/d' /etc/hosts
```

---

## Production Notes

> **1. Use a Real Domain and TLS**
> In production, replace `demo.local` with your real domain and add TLS:
> ```yaml
> spec:
>   tls:
>   - hosts:
>     - yourdomain.com
>     secretName: tls-secret
>   rules:
>   - host: yourdomain.com
> ```
> Use [cert-manager](https://cert-manager.io/) to automatically provision Let's Encrypt certificates.

> **2. Use `Exact` PathType for API routes**
> `Prefix` matches `/app1`, `/app1/anything`. Use `Exact` for strict path matching when needed.

> **3. Add Rate Limiting**
> ```yaml
> annotations:
>   nginx.ingress.kubernetes.io/limit-rps: "10"
> ```

> **4. On Cloud Providers (EKS/GKE/AKS)**
> The Ingress Controller provisions a cloud Load Balancer (ALB/NLB) automatically. No need for `minikube addons enable ingress`.

---

## Key Learnings

- Kubernetes Ingress vs NodePort vs LoadBalancer
- Nginx Ingress Controller setup on Minikube
- `ingressClassName: nginx` (required for modern controller)
- Path-based routing (`/app1`, `/app2`)
- `rewrite-target` annotation (strip path prefix)
- `host`-based routing
- Adding entries to `/etc/hosts` for local DNS testing
- Namespace isolation
- Resource requests and limits on deployments
- TLS/HTTPS upgrade path with cert-manager
