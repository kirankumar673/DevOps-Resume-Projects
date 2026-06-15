# Project 05 - Multi-Container Application Using Docker Compose

## Problem Statement

Your company has developed an application with three components:

- Frontend (Nginx serving HTML)
- Backend API (Python Flask)
- PostgreSQL Database

Current Problems:

- Running multiple containers manually with `docker run`
- Complex startup order — database must be ready before backend starts
- Hardcoded credentials
- Data lost when containers restart (no persistent volume)
- No health monitoring

Build a solution using Docker Compose.

---

## Architecture

```
User
  │
  ▼ Port 80
Frontend Container (nginx:1.27)
  │  Serves static HTML
  │
  ▼ Port 5000
Backend Container (Python Flask + Gunicorn)
  │  REST API
  │
  ▼ Port 5432
PostgreSQL Container (postgres:15)
     Persistent Volume (postgres_data)
```

---

## Project Structure

```
05-docker-compose-project/
├── docker-compose.yml
├── .env.example          ← Copy this to .env and fill in your values
├── frontend/
│   └── index.html
└── backend/
    ├── app.py
    ├── requirements.txt
    ├── Dockerfile
    └── .dockerignore
```

---

## Prerequisites

- Docker installed → [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose installed (included with Docker Desktop)

Verify both are installed:

```bash
docker --version
docker compose version
```

---

## Step 1 - Clone / Enter the Project Directory

```bash
cd 05-docker-compose-project
```

---

## Step 2 - Set Up Environment Variables

> ⚠️ **Never hardcode database credentials in docker-compose.yml.** Use a `.env` file instead.

Copy the example file:

```bash
cp .env.example .env
```

Open `.env` and set your values:

```
POSTGRES_USER=admin
POSTGRES_PASSWORD=your_strong_password_here
POSTGRES_DB=appdb
```

> ⚠️ Add `.env` to your `.gitignore` — never commit it to Git.

---

## Step 3 - Review Key Files

### docker-compose.yml (summary)

```yaml
services:
  frontend:
    image: nginx:1.27
    ports: ["80:80"]
    depends_on:
      backend:
        condition: service_healthy    # waits for backend health check

  backend:
    build: ./backend
    ports: ["5000:5000"]
    depends_on:
      postgres:
        condition: service_healthy    # waits for postgres to be ready
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"]

  postgres:
    image: postgres:15
    volumes:
      - postgres_data:/var/lib/postgresql/data   # data persists across restarts
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]

volumes:
  postgres_data:
```

> ℹ️ Key decisions:
> - `depends_on` with `condition: service_healthy` ensures correct startup order
> - Named volume `postgres_data` means database data survives `docker compose down`
> - Credentials pulled from `.env` file — not hardcoded

### backend/Dockerfile (summary)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN useradd -m appuser
USER appuser
EXPOSE 5000
HEALTHCHECK ...
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
```

---

## Step 4 - Start the Application

```bash
docker compose up -d
```

Docker Compose will:
1. Build the backend image from `./backend/Dockerfile`
2. Pull `nginx:1.27` and `postgres:15` images
3. Start postgres first, wait for its health check to pass
4. Start backend, wait for its health check to pass
5. Start frontend

Watch startup progress:

```bash
docker compose logs -f
```

---

## Step 5 - Verify All Containers Are Running and Healthy

```bash
docker compose ps
```

Expected output:

```
NAME                STATUS
frontend            Up (healthy)
backend             Up (healthy)
postgres            Up (healthy)
```

> ℹ️ All three should show `(healthy)` — this confirms health checks are passing.

---

## Step 6 - Access the Frontend

Open in your browser:

```
http://localhost
```

Or with curl:

```bash
curl http://localhost
```

Expected:

```
Docker Compose Project
Frontend Container Running
```

---

## Step 7 - Access the Backend API

```bash
curl http://localhost:5000
```

Expected:

```
Backend Container Running
```

Test the backend health endpoint:

```bash
curl http://localhost:5000/health
```

Expected:

```json
{"status": "healthy"}
```

---

## Step 8 - Verify the Database

Connect to the PostgreSQL container:

```bash
docker compose exec postgres psql -U $POSTGRES_USER -d $POSTGRES_DB
```

Inside psql, verify connection:

```sql
\conninfo
\q
```

Or simply check it's running:

```bash
docker compose exec postgres pg_isready -U $POSTGRES_USER
```

Expected:

```
/var/run/postgresql:5432 - accepting connections
```

---

## Step 9 - View Logs Per Service

```bash
# All services
docker compose logs

# Just backend
docker compose logs backend

# Follow live
docker compose logs -f backend
```

---

## Verification Checklist

✅ All three containers show `(healthy)` status

✅ Frontend accessible at `http://localhost`

✅ Backend accessible at `http://localhost:5000`

✅ Backend `/health` returns `{"status": "healthy"}`

✅ PostgreSQL accepting connections

✅ Credentials loaded from `.env` (not hardcoded)

---

## Cleanup

Stop containers (keep volumes):

```bash
docker compose down
```

Stop containers AND delete the database volume:

```bash
docker compose down -v
```

> ⚠️ `docker compose down -v` will **permanently delete** all PostgreSQL data.

---

## Production Notes

> **1. Use Docker Secrets or a Vault for credentials**
> For production deployments (Docker Swarm / Kubernetes), use Docker Secrets or HashiCorp Vault instead of `.env` files.

> **2. Do not expose PostgreSQL port 5432 publicly**
> Remove the `ports` section from the `postgres` service in production. Containers on the same Compose network can reach each other by service name without exposing the port to the host.

> **3. Backup the named volume**
> ```bash
> docker run --rm -v 05-docker-compose-project_postgres_data:/data \
>   -v $(pwd):/backup alpine tar czf /backup/db-backup.tar.gz /data
> ```

> **4. Use resource limits**
> Add `deploy.resources.limits` to each service to prevent one container from starving others.

---

## Key Learnings

- Docker Compose multi-service orchestration
- `depends_on` with `condition: service_healthy` (startup ordering)
- Service health checks in Docker Compose
- Named volumes for data persistence
- Environment variables via `.env` file (secrets management)
- Inter-container networking (services reach each other by name)
- Gunicorn as production WSGI server
- Non-root user in containers
