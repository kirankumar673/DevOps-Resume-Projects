# Project 02 - Host a Website on AWS EC2 Using Nginx

## Problem Statement

Your company wants to host a website.

Requirements:

- Full control over the server
- Ability to install software
- Ability to host dynamic applications later
- Publicly accessible website

Build a solution using AWS EC2 and Nginx.

---

## Architecture

User
  │
  ▼
Internet
  │
  ▼
Security Group
  │
  ▼
EC2 Instance
  │
  ▼
Nginx
  │
  ▼
Website

---

## Prerequisites

- AWS Account
- EC2 Key Pair
- Basic Linux Knowledge

---

## Step 1 - Launch EC2 Instance

AWS Console

↓

EC2

↓

Launch Instance

Name:

web-server

AMI:

Ubuntu 22.04

Instance Type:

t2.micro

Create Key Pair:

web-server-key

---

## Step 2 - Configure Security Group

Allow:

| Port | Purpose |
|--------|----------|
| 22 | SSH |
| 80 | HTTP |

Launch Instance.

---

## Step 3 - Connect to EC2

Copy Public IP.

Run:

ssh -i web-server-key.pem ubuntu@PUBLIC_IP

Expected:

ubuntu@ip-172-31-x-x

---

## Step 4 - Update Server

Run:

sudo apt update

sudo apt upgrade -y

---

## Step 5 - Install Nginx

Run:

sudo apt install nginx -y

Verify:

systemctl status nginx

Expected:

active (running)

---

## Step 6 - Verify Nginx

Open:

http://PUBLIC_IP

Expected:

Welcome to Nginx

page appears.

---

## Step 7 - Deploy Website

Move to:

cd /var/www/html

Remove default page:

sudo rm index.nginx-debian.html

Create:

sudo nano index.html

Paste website code.

Save.

---

## Step 8 - Reload Nginx

Run:

sudo systemctl restart nginx

---

## Step 9 - Verify Website

Open:

http://PUBLIC_IP

Expected:

Welcome to My Website

Hosted on AWS EC2

---

## Verification

Verify:

✅ EC2 running

✅ SSH working

✅ Nginx running

✅ Website accessible

---

## Expected Output

Welcome to My Website

Hosted on AWS EC2

---

## Cleanup

Terminate EC2 Instance

↓

Delete Security Group

↓

Delete Key Pair

---

## Key Learnings

- EC2
- Security Groups
- SSH
- Linux Administration
- Nginx
- Website Hosting
