# Project 14 - DevSecOps: Secure Container Images Using Trivy and GitHub Actions

## Problem Statement

Your company builds Docker images and deploys them to production without any security checks.

Current Problems:

- Vulnerable OS packages and libraries reaching production
- No security gates in the CI/CD pipeline
- Manual security reviews — slow and inconsistent
- Compliance and audit risks from unscanned images

Build a DevSecOps pipeline that automatically scans every Docker image for vulnerabilities before it can be pushed to the registry.

---

## Architecture

```
Developer pushes code
        │
        ▼
GitHub Repository
        │
        ▼ GitHub Actions triggers
        │
        ├── Job 1: scan  (push + PR)
        │     ├── Build Docker image
        │     ├── Trivy scan → Table output (blocks pipeline on HIGH/CRITICAL)
        │     ├── Trivy scan → SARIF output
        │     └── Upload SARIF → GitHub Security tab
        │           │
        │           ▼ (must pass — no HIGH/CRITICAL CVEs)
        └── Job 2: push  (main branch only)
              ├── Login to DockerHub
              └── Push SHA-tagged + latest image
                  (only security-verified images reach registry)
```

---

## Project Structure

```
14-devsecops-trivy/
├── Dockerfile                          ← Production-grade (gunicorn, non-root, HEALTHCHECK)
├── source-code/
│   ├── app.py                          ← Flask app with /health endpoint
│   └── requirements.txt               ← Pinned dependencies
└── .github/
    └── workflows/
        └── security-scan.yml          ← DevSecOps pipeline (scan + push jobs)
```

---

## Prerequisites

- GitHub Account with a public or private repository
- DockerHub Account → [Sign up free](https://hub.docker.com/)
- Docker installed locally → [Install Docker](https://docs.docker.com/get-docker/)

---

## Step 1 - Add GitHub Secrets

Go to: Repository → **Settings** → **Secrets and variables** → **Actions**

| Secret Name | Value |
|-------------|-------|
| `DOCKER_USERNAME` | Your DockerHub username |
| `DOCKER_PASSWORD` | Your DockerHub access token (not password) |

> ℹ️ Create a DockerHub Access Token: DockerHub → Account Settings → Security → New Access Token

---

## Step 2 - Review Key Files

### source-code/requirements.txt

```
flask==3.0.3
gunicorn==22.0.0
```

> ℹ️ Pinned versions are critical for security scanning — unpinned dependencies can silently pull vulnerable versions.

### Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY source-code/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY source-code/ .
RUN useradd -m appuser
USER appuser
EXPOSE 5000
HEALTHCHECK ...
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
```

> ℹ️ `python:3.11-slim` is chosen deliberately — it has a smaller attack surface than `python:3.11` (full image). Trivy will still find any CVEs in the base image packages.

---

## Step 3 - Review the Security Pipeline

The workflow at `.github/workflows/security-scan.yml` has two jobs:

**Job 1: `scan`** — runs on every push AND pull request:

```yaml
- name: Run Trivy Vulnerability Scan (Table)
  uses: aquasecurity/trivy-action@0.20.0    # Pinned version — not @master!
  with:
    image-ref: username/secure-app:SHA
    format: table
    exit-code: 1              # Pipeline FAILS if HIGH or CRITICAL CVEs found
    ignore-unfixed: true      # Skip CVEs with no available fix
    severity: HIGH,CRITICAL

- name: Upload SARIF to GitHub Security Tab
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: trivy-results.sarif
```

**Job 2: `push`** — runs on push to `main` ONLY, after `scan` passes:
- Images are only pushed to DockerHub if they pass the security scan
- Tagged with git SHA — full traceability

---

## Step 4 - Push Code and Trigger the Pipeline

```bash
git add .
git commit -m "Add DevSecOps security scanning pipeline"
git push origin main
```

---

## Step 5 - Monitor the Workflow

1. Go to GitHub repository → **Actions** tab
2. Click the running **DevSecOps Pipeline** workflow

Expected flow:

```
DevSecOps Pipeline
├── scan   ✅  No HIGH/CRITICAL vulnerabilities found
└── push   ✅  Security-verified image pushed to DockerHub
```

If vulnerabilities ARE found, the pipeline fails at the `scan` job and the `push` job never runs:

```
DevSecOps Pipeline
└── scan   ❌  CRITICAL: CVE-2024-XXXX found in libssl
    push   ⏭️  Skipped (scan failed)
```

---

## Step 6 - View Security Results in GitHub Security Tab

1. Go to repository → **Security** tab
2. Click **Code scanning**
3. View all detected CVEs with:
   - Severity (CRITICAL / HIGH)
   - Package name and version
   - Fixed version (if available)
   - CVE link for full details

---

## Step 7 - View Trivy Scan Output in Workflow Logs

In the Actions tab → `scan` job → `Run Trivy Vulnerability Scan` step:

```
2024-XX-XX  INFO  Vulnerability scanning is enabled
2024-XX-XX  INFO  Secret scanning is enabled

python:3.11-slim (debian 12.5)
═══════════════════════════════════

Total: 0 (HIGH: 0, CRITICAL: 0)

✅ No HIGH or CRITICAL vulnerabilities found.
```

---

## Verification Checklist

✅ GitHub Secrets set (DOCKER_USERNAME, DOCKER_PASSWORD)

✅ Pipeline triggers on push to main

✅ `scan` job builds image and runs Trivy

✅ SARIF results uploaded to GitHub Security tab

✅ `push` job only runs after `scan` passes

✅ Image pushed to DockerHub with git SHA tag

✅ No HIGH/CRITICAL unpatched CVEs in the image

---

## Troubleshooting

**`scan` job fails with "CRITICAL vulnerabilities found":**
- This is the pipeline working correctly — it blocked an insecure image
- Update the base image to a newer version: `FROM python:3.11-slim` → check for newer patches
- Or update the vulnerable package in `requirements.txt`

**`push` job fails — Docker login error:**
- Check `DOCKER_USERNAME` and `DOCKER_PASSWORD` (use Access Token, not password)

**SARIF upload fails — "Resource not accessible by integration":**
- Go to Repository → Settings → Actions → General → Workflow permissions
- Enable: **Read and write permissions**

---

## Cleanup

Delete the workflow:

```bash
git rm .github/workflows/security-scan.yml
git commit -m "Remove security pipeline"
git push
```

---

## Production Notes

> **1. Never Use `@master` for Third-Party Actions**
> `aquasecurity/trivy-action@master` means any update to that action runs in your pipeline without review — a supply chain attack vector. Always pin to a specific version tag: `@0.20.0`.

> **2. Add Trivy for Filesystem/IaC Scanning Too**
> Beyond container images, Trivy can scan your repository code and Terraform files:
> ```yaml
> - uses: aquasecurity/trivy-action@0.20.0
>   with:
>     scan-type: fs
>     scan-ref: .
>     severity: HIGH,CRITICAL
> ```

> **3. Add SBOM Generation**
> Generate a Software Bill of Materials (SBOM) for compliance:
> ```yaml
> - uses: aquasecurity/trivy-action@0.20.0
>   with:
>     format: cyclonedx
>     output: sbom.json
> ```

> **4. Integrate with AWS ECR Image Scanning**
> In production, enable ECR Enhanced Scanning (powered by Inspector) to continuously rescan images even after they're pushed.

---

## Key Learnings

- DevSecOps (shifting security left into CI/CD)
- Trivy vulnerability scanner (image, filesystem, IaC scanning)
- `aquasecurity/trivy-action` (pinned version — not `@master`)
- SARIF format (GitHub Security tab integration)
- `github/codeql-action/upload-sarif` (vulnerability reporting)
- `exit-code: 1` (pipeline security gate — fails on CVEs)
- `ignore-unfixed: true` (only flag fixable vulnerabilities)
- Two-job security pipeline: `scan` must pass before `push`
- Git SHA image tagging (traceability)
- `security-events: write` permission for SARIF upload
- SBOM generation (CycloneDX format)
- Supply chain security (pinning action versions)
