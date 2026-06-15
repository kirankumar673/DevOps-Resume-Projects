# Project 14 - Secure Container Images Using Trivy and GitHub Actions

## Problem Statement

Your company builds Docker images and deploys them to production.

Current Problems:

- Vulnerable packages may reach production
- No security checks in CI/CD
- Manual security reviews
- Compliance risks

Build a DevSecOps pipeline that scans Docker images automatically.

---

## Architecture

Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Build Docker Image
    ├── Trivy Security Scan
    └── Push Image
    │
    ▼
DockerHub

---

## Prerequisites

- GitHub Account
- DockerHub Account
- Docker Installed

---

## Step 1 - Create Project Structure

14-devsecops-trivy/

├── README.md
├── Resume-Points.md
├── Dockerfile
├── source-code/
│   ├── app.py
│   └── requirements.txt
└── .github/
    └── workflows/
        └── security-scan.yml

---

## Step 2 - Create Sample Application

Create source-code/app.py and requirements.txt.

---

## Step 3 - Create Dockerfile

Use Dockerfile provided in this project.

---

## Step 4 - Configure GitHub Secrets

Repository

↓

Settings

↓

Secrets

Add:

DOCKER_USERNAME

DOCKER_PASSWORD

---

## Step 5 - Create Security Pipeline

Use .github/workflows/security-scan.yml provided in this project.

---

## Step 6 - Push Code

git add .

git commit -m "Added Security Pipeline"

git push

---

## Step 7 - Verify Workflow

GitHub

↓

Actions

↓

Workflow Running

Expected:

Trivy Scan Running

---

## Step 8 - Verify Results

Expected:

HIGH Vulnerabilities

CRITICAL Vulnerabilities

(if vulnerabilities exist)

or

No Vulnerabilities Found

---

## Verification

Verify:

✅ Docker Image Built

✅ Trivy Scan Executed

✅ Security Report Generated

✅ Vulnerabilities Detected

---

## Expected Output

Security Scan Completed

---

## Cleanup

Delete Repository

or

Delete Workflow

---

## Key Learnings

- DevSecOps
- Trivy
- GitHub Actions
- Security Scanning
- Vulnerability Management
- Container Security
