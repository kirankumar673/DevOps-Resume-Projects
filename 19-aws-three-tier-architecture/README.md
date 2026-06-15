# Project 19 - Deploy a Three-Tier Application on AWS

## Problem Statement

Your company wants to host a web application on AWS.

Current Problems:

- Everything runs on a single server
- Poor scalability
- Single point of failure
- Database exposed to internet

Build a secure three-tier architecture.

---

# Architecture

Internet
    │
    ▼
Application Load Balancer
    │
    ▼
Web Tier (EC2)
    │
    ▼
Application Tier (EC2)
    │
    ▼
Database Tier (RDS MySQL)

---

# Prerequisites

- AWS Account
- Terraform Installed
- AWS CLI Installed

---

# Step 1 - Create VPC

Create:

10.0.0.0/16

Terraform will create:

- VPC
- Internet Gateway
- Route Tables

---

# Step 2 - Create Subnets

Public Subnets:

10.0.1.0/24
10.0.2.0/24

Private Subnets:

10.0.3.0/24
10.0.4.0/24

Database Subnets:

10.0.5.0/24
10.0.6.0/24

---

# Step 3 - Create Security Groups

ALB Security Group

Allow:

80
443

Web Tier Security Group

Allow:

80

Only from ALB Security Group

Application Tier Security Group

Allow:

8080

Only from Web Tier

Database Security Group

Allow:

3306

Only from Application Tier

---

# Step 4 - Create EC2 Instances

Web Tier:

2 EC2 Instances

Application Tier:

2 EC2 Instances

---

# Step 5 - Create Application Load Balancer

Terraform creates:

ALB
Target Group
Listeners

---

# Step 6 - Create RDS

Database:

MySQL

Deploy in:

Private Subnets

---

# Step 7 - Initialize Terraform

terraform init

---

# Step 8 - Review Plan

terraform plan

---

# Step 9 - Deploy Infrastructure

terraform apply

Type:

yes

Expected:

Infrastructure Created

---

# Step 10 - Verify Components

AWS Console

Verify:

VPC
Subnets
ALB
EC2
RDS

---

# Step 11 - Test Application

Open:

http://ALB-DNS

Expected:

Application Available

---

# Verification

Verify:

✅ ALB Running

✅ Web Tier Running

✅ Application Tier Running

✅ RDS Running

✅ Traffic Flow Working

---

# Expected Output

User
 ↓
ALB
 ↓
Web Tier
 ↓
Application Tier
 ↓
RDS

---

# Cleanup

terraform destroy

---

# Key Learnings

- AWS VPC
- ALB
- EC2
- RDS
- Security Groups
- Network Segmentation
- High Availability
- Terraform
