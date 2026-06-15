# Resume Points — Project 21: Jenkins CI/CD for Kubernetes

---

## Fresher

- Built a Jenkins CI/CD pipeline that automatically builds a Docker image, tags it with the git commit SHA, pushes it to DockerHub, and deploys it to Kubernetes on every build.
- Used `withCredentials` with `usernamePassword` binding for DockerHub authentication — credentials stored in Jenkins Credentials Manager, never hardcoded in the Jenkinsfile.
- Added `kubectl rollout status --timeout=120s` to verify the deployment completed successfully before marking the pipeline as passed.
- Configured a `post` block with automatic `kubectl rollout undo` on failure — rolling back to the previous stable deployment.

---

## Experienced DevOps Engineer

- Designed a production-aligned Jenkins pipeline with `environment` block for centralised variable management, `checkout scm` for SCM-triggered builds, git SHA image tagging (`GIT_COMMIT[0..7]`) for deployment traceability, and idempotent namespace creation.
- Implemented secure credential handling: Docker login via `withCredentials` + `--password-stdin` (never via `-p` flag which leaks to process list), and `docker logout` in the `always` post block to clean up auth tokens.
- Used `kubectl set image` to perform a rolling update after `kubectl apply` — ensuring the new image tag is deployed rather than reusing a cached image from a previous tag.
- Documented Jenkins plugin requirements: Docker Pipeline, Kubernetes CLI, Git, Credentials Binding — and production upgrade paths including Jenkins on Kubernetes (via Helm), shared libraries for DRY pipelines, and Multibranch Pipelines.

---

## LinkedIn Project Description

Built a Jenkins CI/CD pipeline for Kubernetes deployments: `environment` block for variable management, `checkout scm` for webhook-triggered builds, git SHA image tagging, `withCredentials` for secure DockerHub authentication via `--password-stdin`, `kubectl set image` + `kubectl rollout status` for verified rolling updates, and `post` block with automatic `kubectl rollout undo` rollback on failure. Production Dockerfile with layer caching, non-root user, HEALTHCHECK, and gunicorn. Namespace isolation and resource limits on Kubernetes Deployment.

---

## GitHub Project Description

Jenkins CI/CD for Kubernetes — Git SHA image tagging, withCredentials DockerHub auth, kubectl set image + rollout status verification, automatic rollback on failure, namespace isolation, resource limits, liveness/readiness probes, production Dockerfile (gunicorn + non-root + HEALTHCHECK).

---

## How to Explain in an Interview (30 Seconds)

"I built a Jenkins pipeline that builds a Docker image, tags it with the short git SHA for traceability, pushes it to DockerHub using `withCredentials` so the password never appears in logs, then deploys to Kubernetes using `kubectl set image` and waits for `kubectl rollout status` to confirm success. In the `post` block, if anything fails, it automatically runs `kubectl rollout undo` to roll back to the last working version. I also always run `docker logout` in the `always` block so the auth token gets cleaned up regardless of success or failure."

---

## Skills Demonstrated

- Jenkins declarative pipeline (`pipeline`, `stages`, `post`)
- `environment` block (centralised variable management)
- `checkout scm` (SCM webhook integration)
- Git SHA image tagging (`GIT_COMMIT[0..7]`)
- `withCredentials` + `usernamePassword` binding
- `docker login --password-stdin` (secure — no process list exposure)
- `kubectl set image` (rolling image update)
- `kubectl rollout status --timeout` (deployment verification)
- `kubectl rollout undo` (automatic rollback on failure)
- Idempotent namespace creation (`--dry-run=client -o yaml | apply`)
- `docker logout` in `always` post block (credential cleanup)
- Namespace isolation (`jenkins-cicd`)
- Kubernetes resource limits and health probes
- Production Dockerfile (gunicorn, non-root, HEALTHCHECK, layer caching)
- Jenkins Credentials Manager (no hardcoded secrets)
