# Project 03 - Build a CI/CD Pipeline Using GitHub Actions

## Problem Statement

Your company wants deployments to happen automatically whenever developers push code to GitHub.

Current Problems:

- Manual deployments
- Human errors
- Slow releases
- No automated testing

Build a CI/CD pipeline using GitHub Actions.

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
   ├── Checkout Code
   ├── Run Tests
   ├── Build Application
   └── Deploy
   │
   ▼
Production Environment

---

## Prerequisites

- GitHub Account
- Git Installed
- Sample Application
- Basic Git Knowledge

---

## Step 1 - Create GitHub Repository

GitHub

↓

New Repository

Repository Name:

github-actions-demo

Clone Repository:

git clone <repository-url>

---

## Step 2 - Create Sample Application

Create:

source-code/index.html

---

## Step 3 - Create Workflow Directory

Create:

.github/workflows

---

## Step 4 - Create Workflow File

Create:

.github/workflows/deploy.yml

Paste:

name: Deploy Website

on:
  push:
    branches:
      - main

jobs:

  build:

    runs-on: ubuntu-latest

    steps:

      - name: Checkout Code
        uses: actions/checkout@v4

      - name: List Files
        run: ls -la

      - name: Deployment Successful
        run: echo "Deployment Completed"

---

## Step 5 - Commit Code

Run:

git add .

git commit -m "Added GitHub Actions Workflow"

git push

---

## Step 6 - Verify Workflow

GitHub

↓

Actions Tab

Expected:

Workflow Running

---

## Step 7 - Verify Success

Expected:

Deployment Completed

inside workflow logs.

---

## Verification

Verify:

✅ Workflow triggered automatically

✅ Workflow completed successfully

✅ Actions tab shows successful run

---

## Expected Output

Workflow completed successfully

---

## Cleanup

Delete Repository

or

Delete Workflow File

---

## Key Learnings

- GitHub Actions
- CI/CD
- Workflows
- Automation
- GitHub Repositories
- Pipeline Basics
