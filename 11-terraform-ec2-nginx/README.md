# Project 11 - Provision and Configure an EC2 Web Server Using Terraform

## Problem Statement

Your company wants a web server to be created automatically.

Current Problems:

- Manual EC2 creation
- Manual SSH login
- Manual Nginx installation
- Time-consuming setup

Build a solution using Terraform that:

- Creates EC2
- Creates Security Group
- Installs Nginx automatically
- Hosts a website automatically

---

## Architecture

Terraform
    │
    ▼
AWS EC2
    │
    ▼
User Data Script
    │
    ▼
Install Nginx
    │
    ▼
Deploy Website
    │
    ▼
User

---

## Prerequisites

- AWS Account
- Terraform Installed
- AWS CLI Configured

---

## Step 1 - Create Project Structure

11-terraform-ec2-nginx/

├── README.md
├── Resume-Points.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── user-data.sh

---

## Step 2 - Create User Data Script

Use user-data.sh provided in this project.

---

## Step 3 - Create Provider

Terraform provider configuration is available in main.tf

---

## Step 4 - Create Security Group

Allow:

22 SSH
80 HTTP

---

## Step 5 - Create EC2 Instance

Terraform uses:

user_data = file("user-data.sh")

Terraform will automatically:

- Create EC2
- Execute script
- Install Nginx
- Deploy website

---

## Step 6 - Initialize Terraform

terraform init

---

## Step 7 - Review Plan

terraform plan

---

## Step 8 - Create Infrastructure

terraform apply

Type:

yes

---

## Step 9 - Verify EC2

AWS Console

↓

EC2 Running

---

## Step 10 - Access Website

Copy Public IP

Open:

http://PUBLIC-IP

Expected:

Hello From Terraform

---

## Verification

Verify:

✅ EC2 Running

✅ Nginx Installed

✅ Website Accessible

✅ Terraform Successful

---

## Expected Output

Hello From Terraform

---

## Cleanup

terraform destroy

Type:

yes

---

## Key Learnings

- Terraform
- User Data
- EC2 Automation
- Nginx
- Infrastructure as Code
- Server Provisioning
