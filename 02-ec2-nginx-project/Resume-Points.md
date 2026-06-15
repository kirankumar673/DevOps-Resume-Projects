# Resume Points — Project 02: EC2 Website Hosting with Nginx

---

## Fresher

- Launched and configured an AWS EC2 Ubuntu instance and hosted a website using the Nginx web server.
- Configured Security Groups with least-privilege rules — restricted SSH (port 22) to specific IP, opened HTTP (80) and HTTPS (443) to public.
- Connected to EC2 securely using SSH with `chmod 400` key permissions and deployed files using `scp`.
- Enabled Nginx auto-start on reboot using `systemctl enable` to ensure service availability after server restarts.

---

## Experienced DevOps Engineer

- Provisioned and hardened AWS EC2 instances — configured Security Groups with port-level access controls and restricted SSH access to authorised IPs only.
- Deployed and managed Nginx web server on Ubuntu Linux, including installation, configuration, service management, and auto-start configuration.
- Deployed website files to production servers using `scp` (secure copy) for file transfer without manual server editing.
- Documented an HTTPS upgrade path using Certbot (Let's Encrypt) and an Elastic IP strategy for stable public addressing.

---

## LinkedIn Project Description

Deployed a website on AWS EC2 using Ubuntu Linux and Nginx. Configured Security Groups with production-grade rules (SSH restricted to specific IP, HTTP/HTTPS open), connected via SSH with proper key permissions, deployed files using SCP, and enabled Nginx auto-start with `systemctl enable`. Documented production upgrade paths including HTTPS with Certbot/Let's Encrypt, Elastic IP for static addressing, and ALB for high availability.

---

## GitHub Project Description

AWS EC2 + Nginx Website Hosting — Production-focused deployment covering Security Group hardening, SSH key management, `scp` file deployment, `systemctl enable` for service persistence, and documented upgrade paths for HTTPS (Certbot), Elastic IP, and Application Load Balancer.

---

## How to Explain in an Interview (30 Seconds)

"I launched an Ubuntu EC2 instance, configured Security Groups restricting SSH to my IP only with HTTP and HTTPS open publicly, and connected via SSH with correct key permissions. I installed Nginx, enabled it with `systemctl enable` so it auto-starts on reboot, and deployed my website files using `scp` instead of editing directly on the server. I also documented how to add HTTPS using Certbot and an Elastic IP for a permanent public address — which are standard production requirements."

---

## Skills Demonstrated

- AWS EC2 (Launch, configure, connect)
- AWS Security Groups (Port-level firewall rules, least-privilege)
- SSH Key Management (`chmod 400`, key pair creation)
- Linux Administration (Ubuntu, `apt`, package management)
- Nginx Web Server (Installation, configuration, service management)
- `systemctl` (enable, start, restart, status)
- `scp` (Secure file transfer to remote servers)
- HTTPS with Certbot / Let's Encrypt (production upgrade path)
- AWS Elastic IP (static public addressing)
- AWS Application Load Balancer (high availability — upgrade path)
- Troubleshooting (SSH errors, Nginx 403, service failures)
