# Project 10 - Provision AWS Infrastructure Using Terraform

## Problem Statement

Your company wants to provision AWS infrastructure.

Current Problems:

- Manual resource creation
- Human errors
- No version control
- Difficult environment replication

Build infrastructure using Terraform.

---

## Architecture

Terraform
    │
    ▼
AWS
    │
    ├── VPC
    ├── Subnet
    ├── Security Group
    └── EC2 Instance

---

## Prerequisites

- AWS Account
- Terraform Installed
- AWS CLI Installed

---

## Step 1 - Configure AWS CLI

Run:

aws configure

Provide:

Access Key
Secret Key
Region
Output Format

Verify:

aws sts get-caller-identity

---

## Step 2 - Create Project Structure

terraform-aws-project/

├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars

---

## Step 3 - Create Provider Configuration

Use main.tf provided in this project.

---

## Step 4 - Create VPC

Terraform will create VPC.

---

## Step 5 - Create Subnet

Terraform will create public subnet.

---

## Step 6 - Create Security Group

Terraform will create security group allowing:

- SSH (22)
- HTTP (80)

---

## Step 7 - Create EC2 Instance

Terraform will provision EC2 instance.

---

## Step 8 - Create Variables

Use variables.tf.

---

## Step 9 - Create terraform.tfvars

Update region and AMI ID.

---

## Step 10 - Initialize Terraform

terraform init

Expected:

Terraform has been successfully initialized

---

## Step 11 - Validate Configuration

terraform validate

Expected:

Success

---

## Step 12 - Review Plan

terraform plan

Expected:

Resources to be created

---

## Step 13 - Create Infrastructure

terraform apply

Type:

yes

Expected:

Apply complete

---

## Step 14 - Verify Resources

AWS Console

Verify:

- VPC
- Subnet
- Security Group
- EC2

created successfully.

---

## Verification

Verify:

✅ Terraform Initialized

✅ Plan Successful

✅ Infrastructure Created

✅ EC2 Running

---

## Expected Output

VPC Created

Subnet Created

Security Group Created

EC2 Created

---

## Cleanup

terraform destroy

Type:

yes

---

## Key Learnings

- Terraform
- Infrastructure as Code
- AWS
- VPC
- Subnet
- Security Groups
- EC2
- State Management
