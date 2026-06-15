# Project 20 - Build Reusable Terraform Modules for AWS Infrastructure

## Problem Statement

Your company uses Terraform extensively.

Current Problems:

- Duplicate Terraform code
- Difficult maintenance
- Inconsistent infrastructure
- Poor scalability

Build reusable Terraform modules.

---

# Architecture

Terraform Root Module
        │
        ▼
 VPC Module
        │
        ▼
 EC2 Module
        │
        ▼
 ALB Module
        │
        ▼
 RDS Module

---

# Prerequisites

- AWS Account
- Terraform Installed
- AWS CLI Installed

---

# Step 1 - Create Project Structure

20-terraform-modules/

├── README.md
├── Resume-Points.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── providers.tf
└── modules/

---

# Step 2 - Create VPC Module

Use files inside modules/vpc/

---

# Step 3 - Create EC2 Module

Use files inside modules/ec2/

---

# Step 4 - Create ALB Module

Use files inside modules/alb/

---

# Step 5 - Create RDS Module

Use files inside modules/rds/

---

# Step 6 - Use Modules

Root main.tf consumes all modules.

---

# Step 7 - Initialize Terraform

terraform init

Expected:

Modules downloaded

---

# Step 8 - Validate

terraform validate

Expected:

Success

---

# Step 9 - Review Plan

terraform plan

---

# Step 10 - Deploy Infrastructure

terraform apply

Type:

yes

Expected:

Infrastructure Created

---

# Step 11 - Verify Resources

AWS Console

Verify:

VPC

EC2

ALB

RDS

---

# Verification

Verify:

✅ Modules Working

✅ Infrastructure Created

✅ Outputs Generated

✅ Reusable Architecture

---

# Expected Output

VPC Created

EC2 Created

ALB Created

RDS Created

---

# Cleanup

terraform destroy

---

# Key Learnings

- Terraform Modules
- Reusable Infrastructure
- Infrastructure as Code
- AWS
- Code Organization
- Production Terraform Design
