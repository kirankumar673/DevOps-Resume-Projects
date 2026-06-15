# Resume Points — Project 23: Complete DevSecOps Platform

---

## Fresher

- Built a complete end-to-end DevSecOps pipeline: SonarQube Quality Gate → Trivy container security scan → Docker push → GitOps manifest update → ArgoCD auto-deploys to Amazon EKS.
- Configured Trivy with `--exit-code 1 --ignore-unfixed --severity HIGH,CRITICAL` so the pipeline fails on fixable HIGH/CRITICAL CVEs, and archived the `trivy-report.txt` as a Jenkins build artifact.
- Implemented GitOps update stage: after Docker push, the pipeline uses `sed` to update the image tag in the GitOps manifest repository and commits `[skip ci]` so ArgoCD detects the change without triggering another pipeline run.
- Used Jenkins Credentials Manager for all secrets: `dockerhub-credentials` for Docker push, `github-credentials` for GitOps repo update, and `withSonarQubeEnv` for SonarQube token injection.

---

## Experienced DevOps Engineer

- Designed a five-stage DevSecOps pipeline integrating every layer of the software delivery lifecycle: code quality (SonarQube), security scanning (Trivy), artifact management (DockerHub), GitOps workflow (manifest repo update), and production deployment (ArgoCD → EKS).
- Used `archiveArtifacts artifacts: 'trivy-report.txt'` on `always()` so the Trivy vulnerability report is retained as a Jenkins build artifact regardless of pass/fail — enabling audit and compliance review.
- Implemented GitOps separation of concerns: the Jenkins pipeline only updates image tags in a separate manifest repository, never deploying directly to EKS. ArgoCD owns the deployment — providing audit history, drift detection, and self-healing on the cluster.
- Documented the full toolchain integration: SonarQube server config in Jenkins, Trivy installation on Jenkins agent, GitHub token for manifest repo, and ArgoCD webhook for instant sync.

---

## LinkedIn Project Description

Built a production-grade five-stage DevSecOps pipeline: SonarQube quality gate (withSonarQubeEnv + waitForQualityGate), Trivy image scan (--exit-code 1, --ignore-unfixed, archived report), Docker push with SHA tagging, GitOps manifest update via sed + git commit [skip ci], and ArgoCD auto-deployment to Amazon EKS. All credentials managed via Jenkins Credentials Manager (withCredentials). Implemented GitOps separation: Jenkins updates manifests, ArgoCD owns deployments — providing audit history, drift detection, and self-healing.

---

## GitHub Project Description

Complete DevSecOps Platform — 5-stage Jenkins pipeline: SonarQube Quality Gate → Trivy CVE scan → Docker push (SHA-tagged) → GitOps manifest update → ArgoCD auto-deploy to EKS. withCredentials for all secrets, archived Trivy report, [skip ci] commit strategy, GitOps separation of concerns.

---

## How to Explain in an Interview (30 Seconds)

"I built a complete DevSecOps pipeline with five stages. First, SonarQube runs a quality gate — if code has too many bugs or vulnerabilities, the pipeline stops. Then Trivy scans the Docker image for HIGH and CRITICAL CVEs — if it finds fixable ones, the pipeline stops and saves the report as a build artifact. Only after both gates pass does the image get pushed to DockerHub with the git SHA tag. Then instead of running `kubectl apply` directly, the pipeline updates the image tag in a separate GitOps manifest repository and commits it with `[skip ci]`. ArgoCD detects that commit and deploys to EKS automatically. This way Jenkins handles CI and ArgoCD handles CD — with full audit history."

---

## Skills Demonstrated

- Full DevSecOps pipeline (SonarQube + Trivy + Docker + GitOps + ArgoCD + EKS)
- `withSonarQubeEnv` + `waitForQualityGate abortPipeline: true`
- Trivy `--exit-code 1 --ignore-unfixed --severity HIGH,CRITICAL`
- `archiveArtifacts` for Trivy report (audit compliance)
- Git SHA Docker image tagging (deployment traceability)
- GitOps manifest update via `sed` + `git commit [skip ci]`
- `withCredentials` for DockerHub, GitHub, SonarQube (no hardcoded secrets)
- GitOps separation of concerns (Jenkins = CI, ArgoCD = CD)
- ArgoCD auto-sync + drift detection on Amazon EKS
- `docker login --password-stdin` (secure auth)
- `timeout` + `post` blocks (resilient pipeline design)
- ArgoCD webhook for instant sync (production pattern)
- Jenkins shared libraries for DRY multi-project pipelines
