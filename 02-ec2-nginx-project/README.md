# Project 02 - Host a Website on AWS EC2 Using Nginx

## Problem Statement

Your company wants to host a website with full server control.

Requirements:

- Full control over the server and software
- Ability to install any software or runtime
- Ability to host dynamic applications in the future
- Publicly accessible website

Build a solution using AWS EC2 and the Nginx web server.

---

## Architecture

```
User (Browser)
      │
      ▼ Port 80 (HTTP)
AWS Security Group
(Firewall — allows 22, 80, 443)
      │
      ▼
EC2 Instance (Ubuntu 22.04, t2.micro)
      │
      ▼
Nginx Web Server
      │
      ▼
/var/www/html/index.html
```

---

## Project Structure

```
02-ec2-nginx-project/
└── source-code/
    └── index.html     ← Website file to deploy on the server
```

---

## Prerequisites

- AWS Account → [Sign up free](https://aws.amazon.com/free/)
- SSH client:
  - **macOS/Linux** — built-in terminal
  - **Windows** — [PuTTY](https://www.putty.org/) or Windows Terminal
- Basic Linux command line knowledge

---

## Step 1 - Launch an EC2 Instance

1. Log in to [AWS Console](https://console.aws.amazon.com)
2. Search for **EC2** and click it
3. Click **Launch Instance**
4. Fill in the following:

| Field | Value |
|-------|-------|
| Name | `web-server` |
| AMI | `Ubuntu Server 22.04 LTS` |
| Instance type | `t2.micro` (free tier eligible) |
| Key pair | Click **Create new key pair** → Name: `web-server-key` → Type: RSA → Format: `.pem` → Download it |

5. Click **Launch Instance**

> ℹ️ The `.pem` key file will be downloaded automatically. Keep it safe — you cannot download it again.

---

## Step 2 - Configure Security Group

During launch (or after via Security Groups):

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 22 | TCP | **Your IP only** | SSH access |
| 80 | TCP | 0.0.0.0/0 | HTTP web traffic |
| 443 | TCP | 0.0.0.0/0 | HTTPS web traffic |

> ⚠️ **Critical Security Rule:** Set Port 22 source to **My IP** — never `0.0.0.0/0`.
> Opening SSH to the entire internet exposes your server to brute force attacks.

---

## Step 3 - Connect to the EC2 Instance via SSH

### Find Your Public IP

1. Go to EC2 → **Instances**
2. Click your instance
3. Copy the **Public IPv4 address** (e.g., `13.234.xx.xx`)

### Set Key File Permissions

On **macOS/Linux**, SSH will refuse to connect if the key file is not restricted:

```bash
chmod 400 web-server-key.pem
```

### Connect via SSH

```bash
ssh -i web-server-key.pem ubuntu@YOUR_PUBLIC_IP
```

Replace `YOUR_PUBLIC_IP` with your actual EC2 public IP address.

Expected — you are now inside the server:

```
Welcome to Ubuntu 22.04 LTS
ubuntu@ip-172-31-xx-xx:~$
```

---

## Step 4 - Update the Server

Always update packages before installing anything on a new server:

```bash
sudo apt update
sudo apt upgrade -y
```

Expected at the end:

```
0 upgraded, 0 newly installed, 0 to remove
```

---

## Step 5 - Install Nginx

```bash
sudo apt install nginx -y
```

Enable Nginx to start automatically on every server reboot:

```bash
sudo systemctl enable nginx
```

Verify Nginx is running:

```bash
systemctl status nginx
```

Expected output (look for `active (running)`):

```
● nginx.service - A high performance web server
   Loaded: loaded
   Active: active (running) since ...
```

Press `q` to exit.

---

## Step 6 - Verify the Default Nginx Page

Open your browser and go to:

```
http://YOUR_PUBLIC_IP
```

Expected — the default Nginx welcome page appears:

```
Welcome to nginx!
If you see this page, the nginx web server is successfully installed...
```

> ℹ️ This confirms Nginx is installed, running, and your Security Group allows port 80.

---

## Step 7 - Deploy Your Website

You have two options:

---

### Option A — Upload from Your Local Machine (Recommended)

Run this from your **local terminal** (not the server):

```bash
scp -i web-server-key.pem source-code/index.html ubuntu@YOUR_PUBLIC_IP:/tmp/index.html
```

Then **on the server**, move the file to Nginx's web root:

```bash
sudo mv /tmp/index.html /var/www/html/index.html
sudo rm -f /var/www/html/index.nginx-debian.html
```

---

### Option B — Edit Directly on the Server

```bash
cd /var/www/html
sudo rm -f index.nginx-debian.html
sudo nano index.html
```

Paste the following content:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tech With Sandesh</title>
  <style>
    body {
      text-align: center;
      margin-top: 100px;
      font-family: Arial, sans-serif;
    }
  </style>
</head>
<body>
  <h1>Welcome to My Website</h1>
  <p>Hosted on AWS EC2</p>
</body>
</html>
```

Save and exit: press `Ctrl+X` → `Y` → `Enter`

---

## Step 8 - Restart Nginx

```bash
sudo systemctl restart nginx
```

Verify Nginx is still running after restart:

```bash
systemctl status nginx
```

Expected:

```
Active: active (running)
```

---

## Step 9 - Verify Your Website

Open your browser:

```
http://YOUR_PUBLIC_IP
```

Expected output in browser:

```
Welcome to My Website
Hosted on AWS EC2
```

Or test with curl from your local machine:

```bash
curl http://YOUR_PUBLIC_IP
```

---

## Verification Checklist

✅ EC2 instance in `Running` state

✅ Key file has correct permissions (`chmod 400`)

✅ SSH connection successful (`ubuntu@ip-...` prompt shown)

✅ `apt update && apt upgrade` completed

✅ Nginx installed and `active (running)`

✅ `systemctl enable nginx` run (auto-starts on reboot)

✅ Default Nginx page visible at `http://YOUR_PUBLIC_IP`

✅ Custom `index.html` deployed to `/var/www/html/`

✅ Custom website visible at `http://YOUR_PUBLIC_IP`

---

## Troubleshooting

**SSH: `Permission denied (publickey)`**
- Check you ran `chmod 400 web-server-key.pem`
- Make sure you're using `ubuntu@` (not `ec2-user@` — that's Amazon Linux)
- Confirm the key pair matches the one used when launching the instance

**SSH: `Connection timed out`**
- Check the Security Group has Port 22 open to your IP
- Confirm the EC2 instance is in `Running` state (not `Stopped`)

**Browser shows old Nginx page after deploying:**
- Hard refresh your browser: `Ctrl + Shift + R` (Windows/Linux) or `Cmd + Shift + R` (Mac)
- Run `sudo systemctl restart nginx` on the server

**403 Forbidden:**
- Check file permissions: `ls -la /var/www/html/`
- Fix with: `sudo chmod 644 /var/www/html/index.html`

---

## Cleanup

To avoid ongoing AWS charges, terminate the instance:

1. Go to EC2 → **Instances**
2. Select your instance
3. Click **Instance state** → **Terminate instance**
4. Confirm termination

Then clean up:

1. Go to **Security Groups** → Delete `web-server` security group
2. Go to **Key Pairs** → Delete `web-server-key`

---

## Production Notes

> **1. Enable HTTPS with Let's Encrypt (Certbot)**
> This setup serves HTTP only. For HTTPS with a free SSL certificate:
> ```bash
> sudo apt install certbot python3-certbot-nginx -y
> sudo certbot --nginx -d yourdomain.com
> ```
> Certbot automatically configures Nginx and sets up auto-renewal.

> **2. Allocate an Elastic IP**
> EC2 public IPs change every time you stop and start an instance.
> Go to **EC2 → Elastic IPs → Allocate** then associate it with your instance to get a permanent IP.

> **3. Never Open SSH to 0.0.0.0/0**
> Always restrict Port 22 to your own IP in the Security Group.
> If you need access from multiple locations, use AWS Systems Manager Session Manager instead of SSH.

> **4. Use a Load Balancer for High Availability**
> A single EC2 is a single point of failure. For production, place EC2 behind an
> **Application Load Balancer (ALB)** with an **Auto Scaling Group** across multiple Availability Zones.

---

## Key Learnings

- Launching and configuring an AWS EC2 instance
- Security Groups (firewall rules — ports, protocols, sources)
- SSH key pair creation and `chmod 400` permissions
- Connecting to EC2 via SSH
- Linux package management (`apt update`, `apt install`)
- Nginx installation and service management (`systemctl`)
- `systemctl enable` for auto-start on reboot
- Deploying files via `scp` (secure copy)
- Nginx web root (`/var/www/html/`)
- HTTPS with Certbot and Let's Encrypt
- Elastic IP for a permanent public address
