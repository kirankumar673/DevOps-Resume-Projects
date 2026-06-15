# Resume Points — Project 14: DevSecOps with Trivy

---

## Fresher

- Built a DevSecOps pipeline using GitHub Actions and Trivy that automatically scans Docker images for HIGH and CRITICAL CVEs before they can reach the registry.
- Pinned `aquasecurity/trivy-action` to a specific version (`@0.20.0`) instead of `@master` — preventing supply chain attacks from unreviewed upstream changes.
- Uploaded Trivy scan results in SARIF format to the GitHub Security tab using `github/codeql-action/upload-sarif` for centralised vulnerability tracking.
- Separated the pipeline into `scan` and `push` jobs — images are only pushed to DockerHub if the security scan passes (`exit-code: 1`).

---

## Experienced DevOps Engineer

- Designed a DevSecOps pipeline implementing "shift-left security" — Trivy vulnerability scanning runs on every push and pull request, blocking HIGH and CRITICAL CVEs before code merges to main.
- Configured `ignore-unfixed: true` to focus on actionable vulnerabilities — only flagging CVEs that have available fixes, reducing alert fatigue.
- Implemented dual Trivy scan formats: `table` for human-readable pipeline output and `sarif` for structured upload to GitHub Security tab for compliance and audit visibility.
- Documented advanced DevSecOps patterns: Trivy filesystem/IaC scanning, SBOM generation (CycloneDX format), and AWS ECR Enhanced Scanning for continuous post-push image monitoring.

---

## LinkedIn Project Description

Built a DevSecOps CI/CD pipeline using GitHub Actions and Trivy: two-job architecture where `scan` runs on every push/PR (blocks pipeline on HIGH/CRITICAL CVEs using `exit-code: 1`) and `push` runs on main only after scan passes. Configured dual output formats — `table` for workflow logs and `sarif` uploaded to GitHub Security tab via `codeql-action/upload-sarif`. Pinned all action versions (not `@master`) to prevent supply chain attacks. Documented SBOM generation, filesystem/IaC scanning, and AWS ECR Enhanced Scanning as production security patterns.

---

## GitHub Project Description

DevSecOps Trivy Pipeline — Two-job GitHub Actions workflow: Trivy image scanning with `exit-code: 1` security gate (HIGH/CRITICAL), SARIF upload to GitHub Security tab, pinned action versions (supply chain security), and push-only-after-scan-passes pattern. Includes Dockerfile with non-root user, HEALTHCHECK, and gunicorn.

---

## How to Explain in an Interview (30 Seconds)

"I built a DevSecOps pipeline using GitHub Actions and Trivy. The key design is two separate jobs: a `scan` job that runs on every push and PR — it builds the image and runs Trivy, and if it finds any HIGH or CRITICAL CVEs with available fixes, the pipeline fails and the image never gets pushed. Only when the scan passes does the `push` job run and publish the image to DockerHub. I also upload the results in SARIF format to the GitHub Security tab so the team has a centralised view of vulnerabilities. I pinned the Trivy action to `@0.20.0` not `@master` — using `@master` means any upstream change runs in your pipeline without review, which is a supply chain risk."

---

## Skills Demonstrated

- DevSecOps (shift-left security, security gates in CI/CD)
- Trivy (container image vulnerability scanning)
- `aquasecurity/trivy-action` (pinned version — supply chain security)
- SARIF format (structured vulnerability reporting)
- `github/codeql-action/upload-sarif` (GitHub Security tab integration)
- `exit-code: 1` (pipeline security gate)
- `ignore-unfixed: true` (actionable vulnerability focus)
- Two-job pipeline: scan blocks push (`needs` dependency)
- `security-events: write` permission (SARIF upload)
- Git SHA image tagging (deployment traceability)
- SBOM generation (CycloneDX format — compliance)
- Trivy filesystem/IaC scanning (advanced pattern)
- AWS ECR Enhanced Scanning (production upgrade path)
- Supply chain security (pinned action versions)
