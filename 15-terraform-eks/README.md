# Project 15 - Provision an Amazon EKS Cluster Using Terraform

## Problem Statement

Your company wants to run Kubernetes on AWS.

Current Problems:

- Managing Kubernetes manually
- Infrastructure inconsistencies
- Difficult cluster creation
- No Infrastructure as Code

Build a solution using Terraform to provision Amazon EKS.

---

## Architecture

Terraform
    │
    ▼
AWS
    │
    ├── VPC
    ├── Public Subnets
    ├── Private Subnets
    ├── EKS Control Plane
    └── Worker Nodes
            │
            ▼
      Kubernetes Cluster

---

## Prerequisites

- AWS Account
- Terraform Installed
- AWS CLI Installed
- kubectl Installed

---

## Step 1 - Configure AWS CLI

aws configure

Verify:

aws sts get-caller-identity

---

## Step 2 - Create Project Structure

15-terraform-eks/

├── README.md
├── Resume-Points.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── providers.tf

---

## Step 3 - Configure Provider

Use providers.tf provided in this project.

---

## Step 4 - Create VPC

Terraform will create:

- VPC
- Public Subnets
- Private Subnets

---

## Step 5 - Create EKS Cluster

Terraform provisions Amazon EKS cluster.

---

## Step 6 - Create Node Group

Terraform provisions worker nodes.

---

## Step 7 - Initialize Terraform

terraform init

---

## Step 8 - Review Plan

terraform plan

---

## Step 9 - Create Infrastructure

terraform apply

Type:

yes

Expected:

EKS Cluster Created

---

## Step 10 - Configure kubectl

aws eks update-kubeconfig --region ap-south-1 --name devops-cluster

Verify:

kubectl get nodes

Expected:

Worker Nodes Ready

---

## Step 11 - Deploy Nginx

kubectl create deployment nginx --image=nginx

kubectl expose deployment nginx --type=LoadBalancer --port=80

---

## Step 12 - Verify Application

kubectl get svc

Expected:

External Load Balancer Created

---

## Verification

Verify:

✅ VPC Created

✅ EKS Cluster Running

✅ Worker Nodes Ready

✅ Application Deployed

---

## Expected Output

Kubernetes Cluster Running on AWS

---

## Cleanup

terraform destroy

---

## Key Learnings

- Amazon EKS
- Terraform
- Kubernetes on AWS
- Managed Kubernetes
- Infrastructure as Code
- Cloud Automation
