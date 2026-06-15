# Project 05 - Multi-Container Application Using Docker Compose

## Problem Statement

Your company has developed an application consisting of:

- Frontend
- Backend API
- PostgreSQL Database

Current Problems:

- Running multiple containers manually
- Complex startup process
- Difficult environment management
- Container networking issues

Build a solution using Docker Compose.

---

## Architecture

User
  │
  ▼
Frontend Container (Nginx)
  │
  ▼
Backend Container (Python Flask)
  │
  ▼
PostgreSQL Container

---

## Prerequisites

- Docker Installed
- Docker Compose Installed
- Basic Docker Knowledge

---

## Step 1 - Create Project Structure

multi-container-app/

├── docker-compose.yml
├── frontend/
│   └── index.html
└── backend/
    ├── app.py
    ├── requirements.txt
    └── Dockerfile

---

## Step 2 - Create Frontend

frontend/index.html

---

## Step 3 - Create Backend

backend/app.py

backend/requirements.txt

backend/Dockerfile

---

## Step 4 - Create Docker Compose File

docker-compose.yml

---

## Step 5 - Start Application

Run:

docker compose up -d

---

## Step 6 - Verify Containers

Run:

docker ps

Expected:

frontend
backend
postgres

running.

---

## Step 7 - Access Frontend

Open:

http://localhost

Expected:

Docker Compose Project

Frontend Container Running

---

## Step 8 - Access Backend

Open:

http://localhost:5000

Expected:

Backend Container Running

---

## Step 9 - Verify Database

Run:

docker exec -it CONTAINER_ID bash

Verify PostgreSQL container running.

---

## Verification

Verify:

✅ Frontend running

✅ Backend running

✅ Database running

✅ All containers healthy

---

## Expected Output

Frontend:

Docker Compose Project

Backend:

Backend Container Running

---

## Cleanup

Stop:

docker compose down

Remove volumes:

docker compose down -v

---

## Key Learnings

- Docker Compose
- Multi-Container Applications
- Container Networking
- PostgreSQL Containers
- Service Discovery
- Application Orchestration
