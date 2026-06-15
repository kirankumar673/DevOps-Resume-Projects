# Resume Points — Project 05: Multi-Container App with Docker Compose

---

## Fresher

- Deployed a three-tier application (Nginx frontend, Python Flask backend, PostgreSQL database) using Docker Compose.
- Configured `depends_on` with `condition: service_healthy` to enforce correct container startup order — backend waits for database, frontend waits for backend.
- Managed sensitive database credentials using a `.env` file instead of hardcoding them in `docker-compose.yml`.
- Added a named Docker volume (`postgres_data`) to persist PostgreSQL data across container restarts.

---

## Experienced DevOps Engineer

- Designed a production-aligned `docker-compose.yml` with health checks on all services, named volumes for data persistence, `restart: unless-stopped` policies, and environment variable injection from a `.env` file.
- Implemented service-level health checks for PostgreSQL (`pg_isready`) and Flask backend (HTTP `/health` endpoint) to enforce correct dependency startup ordering.
- Secured database credentials using environment variable substitution — credentials stored in `.env.example` template, never committed to version control.
- Built a production-grade backend Dockerfile: dependency layer caching, `--no-cache-dir`, non-root user, `HEALTHCHECK`, and Gunicorn WSGI server.
- Added `psycopg2-binary` for PostgreSQL connectivity and pinned all Python dependencies to exact versions.

---

## LinkedIn Project Description

Deployed a three-tier application (Nginx, Python Flask, PostgreSQL) using Docker Compose with production best practices: service health checks on all containers, `depends_on` with `condition: service_healthy` for proper startup ordering, named volumes for database persistence, `.env`-based credential management, `restart: unless-stopped` policies, and Gunicorn as the WSGI server. Created `.env.example` as a safe credential template and documented that `.env` should never be committed to Git.

---

## GitHub Project Description

Docker Compose Multi-Container App — Three-tier architecture (Nginx + Flask + PostgreSQL) with service health checks, startup dependency ordering, named volumes for data persistence, `.env` credential management, non-root containers, Gunicorn, and `restart` policies. Demonstrates production-grade Docker Compose configuration.

---

## How to Explain in an Interview (30 Seconds)

"I built a three-tier application with Docker Compose — Nginx frontend, Flask backend, and PostgreSQL. The key thing I focused on was production correctness: I added health checks to all three containers, used `depends_on` with `condition: service_healthy` so the backend only starts after Postgres is fully ready, stored credentials in a `.env` file instead of hardcoding them, and added a named volume so database data survives restarts. I also used Gunicorn instead of the Flask dev server and ran containers as non-root users."

---

## Skills Demonstrated

- Docker Compose (multi-service orchestration, YAML configuration)
- Service health checks (`healthcheck` in Compose)
- Startup dependency ordering (`depends_on`, `condition: service_healthy`)
- Named Docker volumes (data persistence)
- Environment variable management (`.env` file, `.env.example` template)
- `restart: unless-stopped` (service recovery policy)
- PostgreSQL container management (`pg_isready` health check)
- Nginx as a static file server (pinned `nginx:1.27`)
- Python Flask + Gunicorn (production WSGI serving)
- `psycopg2-binary` (PostgreSQL Python driver)
- Non-root container users (security)
- Dockerfile layer caching and `--no-cache-dir`
- `.dockerignore` (build context optimisation)
- Secrets management (`.env` vs hardcoded credentials)
