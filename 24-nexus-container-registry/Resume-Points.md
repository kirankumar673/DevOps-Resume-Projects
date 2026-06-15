# Resume Points — Project 24: Nexus Container Registry

---

## Fresher

- Deployed a private Nexus Repository container registry using Docker Compose with a pinned image version (`sonatype/nexus3:3.67.1`), named volume for data persistence, and JVM memory tuning via `INSTALL4J_ADD_VM_PARAMS`.
- Created a Docker Hosted Repository in Nexus on port 8082, configured Docker daemon `insecure-registries` for HTTP access, and pushed images tagged with the Nexus registry hostname.
- Built a Jenkins pipeline that authenticates to Nexus using `withCredentials`, tags images with git commit SHA, pushes to the private registry, and deploys to Kubernetes with `kubectl rollout status` verification.
- Documented why a private registry is used: IP compliance, no rate limiting (unlike DockerHub), control over image retention and deletion policies.

---

## Experienced DevOps Engineer

- Deployed Nexus Repository Manager as a private Docker registry with production-aligned Docker Compose configuration: pinned version, `restart: unless-stopped`, both UI (8081) and registry (8082) ports exposed, named volume with explicit driver, and JVM heap tuning to prevent OOM on t3.medium hosts.
- Configured a Jenkins pipeline using `withCredentials` for Nexus authentication via `--password-stdin`, git SHA image tagging, Nexus registry-prefixed image names, and `kubectl set image` + `kubectl rollout status` for verified Kubernetes rolling updates.
- Articulated the key differences between Nexus, DockerHub, and AWS ECR: Nexus offers multi-format support (Docker, npm, Maven, PyPI) making it suitable as a single enterprise artifact platform; ECR is fully managed and integrates natively with IAM and EKS.
- Documented production upgrade paths: HTTPS for the Nexus registry using a reverse proxy (Nginx/Traefik) with TLS, Nexus Pro for HA clustering, and migration path to AWS ECR for cloud-native teams.

---

## LinkedIn Project Description

Deployed Nexus Repository Manager as a private Docker container registry using Docker Compose (pinned version, JVM tuning, named volume, restart policy). Built a Jenkins pipeline with `withCredentials` Nexus authentication, git SHA image tagging, push to private registry, and Kubernetes deployment with `kubectl set image` + `kubectl rollout status`. Configured Docker daemon insecure-registries for Nexus HTTP access. Documented Nexus vs DockerHub vs AWS ECR trade-offs and production HTTPS/HA upgrade paths.

---

## GitHub Project Description

Nexus Container Registry — Docker Compose deployment (pinned version, JVM tuning, restart policy), Jenkins pipeline with withCredentials Nexus auth, git SHA tagging, kubectl deploy + rollout status. Covers insecure-registries config, HTTPS upgrade path, and Nexus vs ECR comparison.

---

## How to Explain in an Interview (30 Seconds)

"I set up Nexus Repository as a private Docker registry. I deployed it with Docker Compose using a pinned image version and JVM memory tuning — without the heap settings, Nexus OOMKills on a small instance. I created a Docker Hosted Repository on port 8082, configured the Docker daemon with `insecure-registries` for HTTP access, then built a Jenkins pipeline that uses `withCredentials` to authenticate, tags images with the git SHA, pushes to Nexus, and deploys to Kubernetes. The reason to use Nexus over DockerHub is no rate limiting, full control over image lifecycle, and it can also host Maven, npm, and PyPI artifacts — one platform for all your team's artifacts."

---

## Skills Demonstrated

- Nexus Repository Manager (private Docker registry)
- Docker Compose (pinned version, restart policy, named volume, JVM tuning)
- `INSTALL4J_ADD_VM_PARAMS` (Nexus JVM heap configuration)
- Docker Hosted Repository (Nexus UI configuration)
- Docker daemon `insecure-registries` configuration
- `docker login --password-stdin` to private registry
- Jenkins `withCredentials` for Nexus authentication
- Git SHA image tagging with registry-prefixed names
- `kubectl set image` + `kubectl rollout status` (verified rolling update)
- Nexus vs DockerHub vs AWS ECR (trade-off analysis)
- HTTPS with Nginx reverse proxy for Nexus (production upgrade)
- Nexus Pro HA clustering (enterprise pattern)
- AWS ECR as cloud-native alternative
