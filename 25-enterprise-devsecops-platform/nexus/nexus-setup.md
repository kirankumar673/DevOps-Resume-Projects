# Nexus Repository Manager Setup

## Deploy Nexus on EC2 using Docker Compose

```bash
# On EC2 instance (from project 25 terraform/jenkins EC2)
docker compose up -d
```

## Verify

```bash
docker ps
```

Expected:
```
CONTAINER ID   IMAGE                        STATUS
xxxxxxxxxxxx   sonatype/nexus3:3.67.1       Up 2 minutes
```

## Access Nexus UI

```
http://EC2_PUBLIC_IP:8081
```

Username: `admin`

Retrieve initial password:

```bash
docker exec -it nexus cat /nexus-data/admin.password
```

## Create Docker Hosted Repository

1. Nexus UI → **Settings** (gear icon) → **Repositories** → **Create Repository**
2. Select: **docker (hosted)**
3. Configure:
   - Name: `docker-hosted`
   - HTTP port: `8082`
   - Allow anonymous docker pull: ✅ (for demo — disable in production)
4. Click **Create repository**

## Configure Docker Daemon for HTTP Registry

On all hosts (Jenkins agent, developer machines):

```bash
sudo nano /etc/docker/daemon.json
```

Add:

```json
{
  "insecure-registries": ["EC2_PUBLIC_IP:8082"]
}
```

Restart Docker:

```bash
sudo systemctl restart docker
```

## Test Push Manually

```bash
docker login EC2_PUBLIC_IP:8082 -u admin -p YOUR_PASSWORD
docker pull nginx:1.27
docker tag nginx:1.27 EC2_PUBLIC_IP:8082/nginx:1.27
docker push EC2_PUBLIC_IP:8082/nginx:1.27
```

Verify in Nexus UI → Browse → docker-hosted → nginx

## Production Notes

> For HTTPS, place Nginx reverse proxy in front of Nexus with an SSL certificate.
> For enterprise use, Nexus Pro supports HA clustering and LDAP/SAML authentication.
> Consider AWS ECR as a fully managed alternative for cloud-native teams.
