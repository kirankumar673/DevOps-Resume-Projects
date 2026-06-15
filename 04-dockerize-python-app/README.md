# Project 04 - Dockerize a Python Application

## Problem Statement

Your company has developed a Python application.

Current Problems:

- Works on developer machine only
- Dependency issues
- Different environments
- Difficult deployment process

Build a solution using Docker so the application can run consistently anywhere.

---

## Architecture

Developer
   │
   ▼
Dockerfile
   │
   ▼
Docker Image
   │
   ▼
Docker Container
   │
   ▼
Python Application

---

## Prerequisites

- Docker Installed
- Python Installed
- Basic Linux Knowledge

---

## Step 1 - Create Application

Create:

source-code/app.py

source-code/requirements.txt

---

## Step 2 - Install Dependencies

Run:

pip install -r requirements.txt

---

## Step 3 - Test Application

Run:

python app.py

Open:

http://localhost:5000

Expected:

Hello From Docker

---

## Step 4 - Create Dockerfile

Create:

Dockerfile

Paste the Dockerfile provided in this project.

---

## Step 5 - Build Docker Image

Run:

docker build -t python-app:v1 .

Verify:

docker images

Expected:

python-app    v1

---

## Step 6 - Run Container

Run:

docker run -d -p 5000:5000 python-app:v1

Verify:

docker ps

Expected:

Container running.

---

## Step 7 - Access Application

Open:

http://localhost:5000

Expected:

Hello From Docker

---

## Step 8 - View Container Logs

Run:

docker logs CONTAINER_ID

---

## Step 9 - Stop Container

Run:

docker stop CONTAINER_ID

---

## Verification

Verify:

✅ Image built successfully

✅ Container running

✅ Application accessible

✅ Logs visible

---

## Expected Output

Hello From Docker

---

## Cleanup

Remove Container:

docker rm CONTAINER_ID

Remove Image:

docker rmi python-app:v1

---

## Key Learnings

- Docker
- Docker Images
- Docker Containers
- Dockerfile
- Container Lifecycle
- Application Packaging
