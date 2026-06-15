# Resume Points — Project 04: Dockerize a Python Application

---

## Fresher

- Containerized a Python Flask application using Docker with a production-grade Dockerfile.
- Optimised Docker image builds using layer caching — copied `requirements.txt` before source code to avoid reinstalling dependencies on every build.
- Used `--no-cache-dir` with pip to reduce Docker image size and avoid bloated layers.
- Added a `/health` endpoint to the Flask application for container health monitoring.

---

## Experienced DevOps Engineer

- Built a production-grade Dockerfile for a Python Flask application — used `python:3.11-slim` base image, `--no-cache-dir`, layer caching, non-root user (`useradd`), `HEALTHCHECK` instruction, and Gunicorn as the WSGI server.
- Replaced Flask's built-in development server with Gunicorn for multi-worker production serving (`--workers 2`).
- Implemented container security best practices: ran application as a non-root user to reduce attack surface.
- Created a `.dockerignore` file to exclude `__pycache__`, `.env`, `.git`, and markdown files from the build context, reducing image size and preventing secret leaks.
- Pinned all Python dependencies to exact versions (`flask==3.0.3`, `gunicorn==22.0.0`) for fully reproducible builds.

---

## LinkedIn Project Description

Containerized a Python Flask application using Docker with production-grade best practices: `python:3.11-slim` base image, dependency layer caching, `--no-cache-dir` for smaller images, non-root user for security, `HEALTHCHECK` instruction for orchestrator integration, Gunicorn WSGI server instead of Flask dev server, and `.dockerignore` to minimise build context. Pinned all dependencies to exact versions for reproducible builds.

---

## GitHub Project Description

Docker Python App — Production-grade Dockerfile with layer caching optimisation, `--no-cache-dir`, non-root user, HEALTHCHECK, Gunicorn WSGI server, pinned dependencies, and `.dockerignore`. Demonstrates security and performance best practices for containerising Python applications.

---

## How to Explain in an Interview (30 Seconds)

"I containerized a Python Flask app using Docker. Instead of a basic Dockerfile, I focused on production best practices: I used `python:3.11-slim` to keep the image small, copied `requirements.txt` before the source code to leverage Docker's layer cache, used `--no-cache-dir` to avoid bloating the image, ran the app as a non-root user for security, added a `HEALTHCHECK` so Kubernetes knows when the container is healthy, and used Gunicorn instead of Flask's dev server for production. I also created a `.dockerignore` to keep the build context clean."

---

## Skills Demonstrated

- Docker (Images, Containers, Build, Run, Logs, Stats)
- Dockerfile (multi-step, production-grade)
- Docker Layer Caching (copy dependencies before code)
- `python:3.11-slim` (minimal base image selection)
- `--no-cache-dir` (image size optimisation)
- Non-root container user (security hardening)
- `HEALTHCHECK` instruction (orchestrator health integration)
- Gunicorn WSGI server (production Python serving)
- `.dockerignore` (build context optimisation, secret protection)
- Dependency pinning (reproducible builds)
- Flask REST API (`/health` endpoint)
- Container lifecycle management (`build`, `run`, `stop`, `rm`, `rmi`)
