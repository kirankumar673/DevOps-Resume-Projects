# Project 03 - Build a CI/CD Pipeline Using GitHub Actions

## Problem Statement

Your company wants deployments to happen automatically whenever developers push code to GitHub.

Current Problems:

- Manual deployments — slow and error-prone
- Human errors during releases
- No automated validation before deploying
- No consistent deployment process

Build a CI/CD pipeline using GitHub Actions that automatically validates and deploys on every push to `main`.

---

## Architecture

```
Developer pushes code
        │
        ▼
GitHub Repository (main branch)
        │
        ▼
GitHub Actions triggered automatically
        │
        ├── Job 1: validate  ──── Runs on push AND pull_request
        │     ├── Checkout code
        │     └── Validate HTML structure
        │           │
        │           ▼ (must pass before deploy runs)
        └── Job 2: deploy  ──── Runs on push to main ONLY
              ├── Checkout code
              ├── Configure AWS credentials (from Secrets)
              └── aws s3 sync → S3 Bucket
```

---

## Project Structure

```
03-github-actions-project/
├── .github/
│   └── workflows/
│       └── deploy.yml       ← The CI/CD pipeline definition
└── source-code/
    └── index.html           ← The application being deployed
```

---

## Prerequisites

- GitHub account → [Sign up free](https://github.com/join)
- Git installed → [Install Git](https://git-scm.com/downloads)
- AWS account (for the deploy job) → [Sign up free](https://aws.amazon.com/free/)
- An S3 bucket already created (from Project 01)

Verify Git is installed:

```bash
git --version
```

---

## Step 1 - Create a GitHub Repository

1. Go to [github.com](https://github.com) and log in
2. Click **+** → **New repository**
3. Fill in:

| Field | Value |
|-------|-------|
| Repository name | `github-actions-demo` |
| Visibility | Public or Private |
| Initialize with README | Yes |

4. Click **Create repository**

Clone it to your local machine:

```bash
git clone https://github.com/YOUR_USERNAME/github-actions-demo.git
cd github-actions-demo
```

---

## Step 2 - Add the Application Files

Copy the source code into the repo:

```bash
mkdir source-code
```

Create `source-code/index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GitHub Actions Demo</title>
  <style>
    body {
      text-align: center;
      margin-top: 100px;
      font-family: Arial, sans-serif;
    }
  </style>
</head>
<body>
  <h1>Hello From GitHub Actions</h1>
  <p>Deployed automatically via CI/CD pipeline</p>
</body>
</html>
```

---

## Step 3 - Create the Workflow Directory

```bash
mkdir -p .github/workflows
```

---

## Step 4 - Create the Workflow File

Create `.github/workflows/deploy.yml` with the following content:

```yaml
name: Deploy Website

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:          # Allows manual trigger from GitHub UI

# Prevent multiple simultaneous deployments
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:

  # ──────────────────────────────────────────
  # JOB 1: Validate (runs on push AND PRs)
  # ──────────────────────────────────────────
  validate:
    name: Validate HTML
    runs-on: ubuntu-latest

    permissions:
      contents: read

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: List Files
        run: ls -la source-code/

      - name: Validate HTML structure
        run: |
          echo "Checking index.html exists..."
          test -f source-code/index.html && echo "✅ index.html found" || (echo "❌ index.html missing" && exit 1)

          echo "Checking DOCTYPE declaration..."
          grep -q "<!DOCTYPE html>" source-code/index.html && echo "✅ DOCTYPE found" || (echo "❌ DOCTYPE missing" && exit 1)

          echo "Checking charset meta tag..."
          grep -q "charset" source-code/index.html && echo "✅ charset found" || (echo "❌ charset meta missing" && exit 1)

          echo "All validations passed ✅"

  # ──────────────────────────────────────────
  # JOB 2: Deploy (runs only on main branch)
  # ──────────────────────────────────────────
  deploy:
    name: Deploy to S3
    runs-on: ubuntu-latest
    needs: validate
    if: github.ref == 'refs/heads/main' && github.event_name != 'pull_request'

    permissions:
      contents: read
      id-token: write

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Deploy to S3
        run: |
          aws s3 sync source-code/ s3://${{ secrets.S3_BUCKET_NAME }} \
            --delete \
            --cache-control "max-age=3600"
          echo "✅ Deployment to S3 completed successfully"

      - name: Invalidate CloudFront Cache (optional)
        if: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID != '' }}
        run: |
          aws cloudfront create-invalidation \
            --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} \
            --paths "/*"
          echo "✅ CloudFront cache invalidated"
```

> ℹ️ Key decisions:
> - **`validate` job** runs on every push AND every pull request — catches problems before they hit main
> - **`deploy` job** only runs when code lands on `main` — not on PRs
> - `needs: validate` — deploy is blocked if validate fails
> - `concurrency` — if you push twice quickly, the older deployment is cancelled
> - `permissions` — least-privilege: only `contents: read` and `id-token: write` (for OIDC)

---

## Step 5 - Add GitHub Secrets

The deploy job needs AWS credentials. **Never hardcode these in the workflow file** — use GitHub Secrets.

1. Go to your GitHub repository
2. Click **Settings** tab
3. In the left sidebar: **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add each of the following:

| Secret Name | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | Your AWS IAM user Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | Your AWS IAM user Secret Access Key |
| `AWS_REGION` | e.g. `ap-south-1` |
| `S3_BUCKET_NAME` | Your S3 bucket name (from Project 01) |
| `CLOUDFRONT_DISTRIBUTION_ID` | (Optional) Your CloudFront distribution ID |

> ⚠️ Secrets are encrypted and never shown in logs. You cannot view them after saving — only overwrite them.

---

## Step 6 - Commit and Push

Add all files and push to GitHub:

```bash
git add .
git commit -m "Add GitHub Actions CI/CD pipeline"
git push origin main
```

---

## Step 7 - Watch the Workflow Run

1. Go to your GitHub repository
2. Click the **Actions** tab
3. You should see a workflow run titled **Deploy Website** triggered by your push

Click on it to see:

```
Deploy Website
├── validate  ✅  (30s)
└── deploy    ✅  (45s)
```

Click any job to see the detailed step logs.

---

## Step 8 - Verify the Deployment

After the `deploy` job completes, open your S3 website URL:

```
http://YOUR-BUCKET-NAME.s3-website-ap-south-1.amazonaws.com
```

Expected:

```
Hello From GitHub Actions
Deployed automatically via CI/CD pipeline
```

---

## Step 9 - Test the Pull Request Flow (Optional but Recommended)

Create a new branch and open a PR to see the validate job run without deploying:

```bash
git checkout -b test-pr
# Make a small change to index.html
git add .
git commit -m "Test PR validation"
git push origin test-pr
```

Then open a Pull Request on GitHub. The `validate` job runs — but `deploy` does NOT (because it's a PR, not a push to main).

---

## Verification Checklist

✅ `.github/workflows/deploy.yml` exists in the repository

✅ GitHub Secrets are configured (all 4 required secrets)

✅ Push to `main` triggers the workflow automatically

✅ `validate` job passes — all HTML checks green

✅ `deploy` job passes — S3 sync completes

✅ S3 website URL shows the updated content

✅ PR only triggers `validate` (not `deploy`)

---

## Troubleshooting

**Workflow not triggering:**
- Confirm the file is at `.github/workflows/deploy.yml` (exact path matters)
- Confirm you pushed to the `main` branch (not `master`)

**`validate` job fails — "index.html missing":**
- Confirm `source-code/index.html` exists in the repo root
- Check the file path in the workflow matches your actual folder name

**`deploy` job fails — "Unable to locate credentials":**
- Check all four secrets are added in GitHub → Settings → Secrets
- Secret names must match exactly (case-sensitive)

**`deploy` job fails — "Access Denied" on S3:**
- The IAM user needs `s3:PutObject`, `s3:DeleteObject`, `s3:ListBucket` permissions on the bucket
- Check the bucket name in `S3_BUCKET_NAME` secret matches exactly

---

## Cleanup

Delete the workflow file:

```bash
git rm .github/workflows/deploy.yml
git commit -m "Remove workflow"
git push origin main
```

Or delete the entire repository:

GitHub → Repository → **Settings** → scroll to bottom → **Delete this repository**

---

## Production Notes

> **1. Use OIDC Instead of Long-Lived AWS Access Keys**
> Long-lived AWS keys stored as secrets are a security risk. Use OpenID Connect (OIDC) for keyless, short-lived authentication:
> - Create a GitHub OIDC Identity Provider in AWS IAM
> - Create an IAM Role with a trust policy scoped to your repo
> - Replace `aws-access-key-id` / `aws-secret-access-key` with `role-to-assume` in the credentials action

> **2. Enable Branch Protection Rules**
> Go to GitHub → Settings → Branches → Add rule for `main`:
> - ✅ Require status checks to pass (`validate` job) before merging
> - ✅ Require pull request reviews before merging
> - ✅ Restrict direct pushes to main

> **3. Pin Action Versions to a Commit SHA**
> Using tags like `@v4` can be overwritten by maintainers. Pin to a full SHA for security:
> ```yaml
> uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4.2.2
> ```

> **4. Add Slack / Email Notifications**
> Add a final step to notify the team on success or failure:
> ```yaml
> - name: Notify on failure
>   if: failure()
>   run: echo "Pipeline failed — notify team here"
> ```

---

## Key Learnings

- GitHub Actions workflow syntax (YAML)
- Event triggers: `push`, `pull_request`, `workflow_dispatch`
- Multi-job pipelines with `needs` (job dependencies)
- Conditional job execution with `if:`
- `concurrency` to prevent overlapping deployments
- GitHub Secrets for secure credential management
- Least-privilege `permissions` per job
- `aws s3 sync` for website deployment
- CloudFront cache invalidation after deploy
- Branch protection rules for safe collaboration
- OIDC keyless AWS authentication (production best practice)
