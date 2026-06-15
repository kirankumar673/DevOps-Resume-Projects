# Resume Points — Project 03: CI/CD Pipeline with GitHub Actions

---

## Fresher

- Built a multi-job CI/CD pipeline using GitHub Actions that automatically triggers on code push and pull requests.
- Implemented a `validate` job to check HTML structure before any deployment runs, preventing broken deployments.
- Stored AWS credentials securely as GitHub Secrets — never hardcoded in workflow files.
- Deployed a static website to AWS S3 automatically using `aws s3 sync` on every push to the main branch.

---

## Experienced DevOps Engineer

- Designed and implemented a production-grade CI/CD pipeline using GitHub Actions with multi-job dependency (`needs`), conditional execution (`if:`), and `concurrency` control to prevent overlapping deployments.
- Configured event-driven pipeline triggers for `push`, `pull_request`, and `workflow_dispatch`, enforcing validation on PRs without deploying — following trunk-based development best practices.
- Applied least-privilege job-level permissions (`contents: read`, `id-token: write`) per GitHub Actions security guidelines.
- Integrated CloudFront cache invalidation post-deployment to ensure users always receive the latest content.
- Documented OIDC-based keyless AWS authentication as a production upgrade path to eliminate long-lived credentials.

---

## LinkedIn Project Description

Built a production-grade CI/CD pipeline using GitHub Actions with two-job architecture: a `validate` job that checks code quality on every push and pull request, and a `deploy` job that automatically syncs to AWS S3 only on successful merges to main. Implemented GitHub Secrets for credential management, concurrency control to prevent race conditions, and CloudFront invalidation post-deployment. Documented OIDC keyless AWS authentication and branch protection rules as production best practices.

---

## GitHub Project Description

GitHub Actions CI/CD Pipeline — Multi-job pipeline with HTML validation, conditional S3 deployment, AWS credentials via GitHub Secrets, concurrency control, CloudFront cache invalidation, and least-privilege job permissions. Includes documented OIDC upgrade path and branch protection recommendations.

---

## How to Explain in an Interview (30 Seconds)

"I built a two-job CI/CD pipeline using GitHub Actions. The first job validates the HTML on every push and pull request. The second job only runs on pushes to main — it deploys to S3 using `aws s3 sync` with AWS credentials stored as GitHub Secrets. I also added concurrency control so parallel pushes don't cause duplicate deployments, and a CloudFront invalidation step so cached content is refreshed after every deploy. In production, I'd replace the access keys with OIDC for keyless authentication."

---

## Skills Demonstrated

- GitHub Actions (workflow YAML, jobs, steps, triggers)
- CI/CD Pipeline Design (validate → deploy pattern)
- Multi-job workflows with `needs` (job dependencies)
- Conditional job execution (`if:` expressions)
- Workflow triggers (`push`, `pull_request`, `workflow_dispatch`)
- Concurrency control (`concurrency`, `cancel-in-progress`)
- GitHub Secrets (secure credential management)
- Least-privilege permissions (`contents: read`, `id-token: write`)
- AWS S3 deployment (`aws s3 sync`, `--delete`, `--cache-control`)
- CloudFront cache invalidation
- OIDC keyless AWS authentication (production upgrade path)
- Branch protection rules (PR review gates, status checks)
- Troubleshooting workflow failures (logs, secret validation)
