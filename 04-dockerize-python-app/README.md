# Project 04 - Dockerize a Python Application

## Problem Statement

Your company has developed a Python application.

Current Problems:

- Works on developer machine only
- Dependency issues across environments
- Difficult deployment process
- No consistent runtime environment

Build a solution using Docker so the application runs consistently anywhere.

---

## Architecture

```
Developer
   │
   ▼
Dockerfile  ←  source-code/app.py
   │            source-code/requirements.txt
   ▼
Docker Image (python-app:v1)
   │
   ▼
Docker Container
   │
   ▼
Python Flask Application (port 5000)
```

---

## Project Structure

```
04-dockerize-python-app/
├── Dockerfile
├── .dockerignore
└── source-code/
    ├── app.py
    └── requirements.txt
```

---

## Prerequisites

- Docker installed → [Install Docker](https://docs.docker.com/get-docker/)
- Basic terminal/command line knowledge

Verify Docker is installed:

```bash
docker --version
```

Expected:

```
Docker version 24.x.x
```

---

## Step 1 - Review the Application Files

### source-code/app.py

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello From Docker"

@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
```

### source-code/requirements.txt

```
flask==3.0.3
gunicorn==22.0.0
```

> ℹ️ Dependencies are **pinned to exact versions** to ensure reproducible builds.

---

## Step 2 - Review the Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Copy dependencies first for better layer caching
COPY source-code/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY source-code/ .

# Run as non-root user for security
RUN useradd -m appuser
USER appuser

EXPOSE 5000

# Health check so orchestrators can detect failures
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"

# Use gunicorn for production (not Flask dev server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
```

> ℹ️ Key decisions:
> - `python:3.11-slim` keeps the image small
> - `requirements.txt` copied before code → faster rebuilds (Docker layer cache)
> - `--no-cache-dir` reduces image size
> - Non-root `appuser` improves security
> - `gunicorn` is a production WSGI server — Flask's built-in server is for dev only
> - `HEALTHCHECK` lets Docker and Kubernetes detect unhealthy containers

---

## Step 3 - Build the Docker Image

Run from the project root directory:

```bash
docker build -t python-app:v1 .
```

Verify the image was created:

```bash
docker images
```

Expected output:

```
REPOSITORY    TAG   IMAGE ID       CREATED        SIZE
python-app    v1    abc123def456   5 seconds ago  150MB
```

---

## Step 4 - Run the Container

```bash
docker run -d -p 5000:5000 --name python-app python-app:v1
```

| Flag | Meaning |
|------|---------|
| `-d` | Run in background (detached mode) |
| `-p 5000:5000` | Map host port 5000 → container port 5000 |
| `--name python-app` | Give the container a readable name |

Verify container is running:

```bash
docker ps
```

Expected:

```
CONTAINER ID   IMAGE           STATUS                    NAMES
abc123         python-app:v1   Up 10 seconds (healthy)   python-app
```

> ℹ️ `(healthy)` confirms the HEALTHCHECK is passing.

---

## Step 5 - Access the Application

Open in your browser or run:

```bash
curl http://localhost:5000
```

Expected:

```
Hello From Docker
```

Test the health endpoint:

```bash
curl http://localhost:5000/health
```

Expected:

```json
{"status": "healthy"}
```

---

## Step 6 - View Container Logs

```bash
docker logs python-app
```

Follow live logs:

```bash
docker logs -f python-app
```

---

## Step 7 - Inspect the Container

Check container details:

```bash
docker inspect python-app
```

Check resource usage:

```bash
docker stats python-app
```

---

## Step 8 - Stop and Remove Container

```bash
docker stop python-app
docker rm python-app
```

---

## Verification Checklist

✅ Image built successfully (`docker images` shows `python-app:v1`)

✅ Container running with `(healthy)` status (`docker ps`)

✅ Application returns `Hello From Docker` on port 5000

✅ `/health` endpoint returns `{"status": "healthy"}`

✅ Logs visible via `docker logs`

---

## Cleanup

Remove the container:

```bash
docker rm -f python-app
```

Remove the image:

```bash
docker rmi python-app:v1
```

---

## Production Notes

> **1. Never use Flask's built-in dev server in production**
> It is single-threaded, not designed for concurrent traffic, and has debug features that are security risks. Always use `gunicorn` or `uwsgi`.

> **2. Run containers as non-root**
> Running as `root` inside a container is a security risk. Always create and switch to a non-root user in your Dockerfile.

> **3. Use `.dockerignore`**
> The `.dockerignore` file prevents `__pycache__`, `.env`, `.git` and other unnecessary files from being copied into the image, keeping it small and secure.

> **4. Push to a Registry for Production**
> To use this image in Kubernetes or any remote server:
> ```bash
> docker tag python-app:v1 yourdockerhubuser/python-app:v1
> docker push yourdockerhubuser/python-app:v1
> ```

---

## Key Learnings

- Docker Images and Containers
- Writing a production-grade Dockerfile
- Docker layer caching (copy `requirements.txt` before code)
- `--no-cache-dir` for smaller images
- Non-root user in containers (security)
- `HEALTHCHECK` instruction
- Gunicorn as a production WSGI server
- `.dockerignore` best practices
- Container lifecycle (`build`, `run`, `stop`, `rm`)
