# Project 24 - Build an Enterprise Container Registry Platform Using Nexus

## Problem Statement

Your company builds Docker images daily.

Current Problems:

- Images stored on developer laptops
- No centralized registry
- No image versioning
- No vulnerability governance
- No artifact management

Build a centralized container registry platform.

---

# Architecture

Developer
    │
    ▼
GitHub
    │
    ▼
Jenkins
    │
    ▼
Docker Build
    │
    ▼
Nexus Repository
    │
    ▼
Kubernetes

---

# Prerequisites

- AWS EC2
- Docker Installed
- Nexus Repository
- Jenkins
- Kubernetes Cluster

---

# Step 1 - Create Project Structure

24-nexus-container-registry/

├── README.md
├── Resume-Points.md
├── docker-compose.yml
├── Jenkinsfile
├── Dockerfile
├── deployment.yaml
├── service.yaml
└── app/
    ├── app.py
    └── requirements.txt

---

# Step 2 - Deploy Nexus

Use docker-compose.yml provided in this project.

---

# Step 3 - Start Nexus

docker-compose up -d

Verify:

docker ps

Expected:

nexus running

---

# Step 4 - Access Nexus

Open:

http://EC2-IP:8081

Login:

admin

Retrieve password:

docker exec -it nexus cat /nexus-data/admin.password

---

# Step 5 - Create Docker Hosted Repository

Nexus → Repositories → Create Repository → Docker Hosted

Port:

8082

Repository:

docker-hosted

---

# Step 6 - Configure Docker

Edit:

/etc/docker/daemon.json

Add insecure registry:

EC2-IP:8082

Restart Docker.

---

# Step 7 - Build Application

Use files provided in app/ folder.

---

# Step 8 - Build Docker Image

docker build -t nexus-app .

docker tag nexus-app EC2-IP:8082/nexus-app:v1

---

# Step 9 - Push Image

docker push EC2-IP:8082/nexus-app:v1

Verify in Nexus.

Expected:

Image Visible

---

# Step 10 - Configure Jenkins

Use Jenkinsfile provided in this project.

---

# Step 11 - Deploy to Kubernetes

Use deployment.yaml provided in this project.

---

# Verification

Verify:

✅ Nexus Running

✅ Docker Repository Created

✅ Image Pushed

✅ Jenkins Integrated

✅ Kubernetes Deployment Successful

---

# Expected Output

Image Stored In Nexus

Application Running

---

# Cleanup

docker-compose down

---

# Key Learnings

- Nexus Repository
- Docker Registry
- Artifact Management
- Image Lifecycle Management
- Jenkins
- Kubernetes
- Enterprise DevOps
