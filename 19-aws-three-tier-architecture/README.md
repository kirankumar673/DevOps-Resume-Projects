# Project 19 - AWS Three-Tier Architecture Using Terraform

## Problem Statement

Your company wants to deploy a web application using a production-grade AWS architecture.

Current Problems:

- Everything runs on a single EC2 instance — single point of failure
- Database is accessible from the internet — security risk
- No load balancing — can't handle traffic spikes
- No environment isolation between tiers

Build a secure, highly available three-tier architecture: Web → Application → Database, with each tier in isolated network segments.

---

## Architecture

```
Internet
    │
    ▼ HTTP/HTTPS (ports 80/443)
Application Load Balancer  [Public Subnets — 2 AZs]
    │
    ▼ HTTP port 80 (ALB SG only)
Web Tier — EC2 × 2        [Public Subnets — 2 AZs]
    │
    ▼ Port 8080 (Web Tier SG only)
App Tier — EC2 × 2        [Private Subnets — 2 AZs]
    │
    ▼ MySQL port 3306 (App Tier SG only)
Database Tier — RDS MySQL  [Database Subnets — 2 AZs — NO internet route]
```

> ℹ️ Each Security Group only allows traffic from the tier directly above it — the database has zero internet exposure.

---

## Project Structure

```
19-aws-three-tier-architecture/
├── providers.tf      ← AWS provider + terraform/required_providers version constraints
├── main.tf           ← VPC, Subnets (3 tiers), IGW, NAT, Route Tables,
│                        Security Groups (4), EC2 (web + app), ALB + Target Group, RDS
├── variables.tf      ← All typed variables with descriptions
├── outputs.tf        ← ALB DNS, instance IDs, RDS endpoint, VPC ID
└── terraform.tfvars  ← Environment-specific values (no passwords!)
```

---

## Prerequisites

- AWS Account with IAM permissions for VPC, EC2, RDS, ALB
- Terraform ≥ 1.3.0 → [Install](https://developer.hashicorp.com/terraform/install)
- AWS CLI configured → `aws configure`
- An existing EC2 Key Pair

---

## Step 1 - Set the Database Password (Environment Variable)

> ⚠️ Never put database passwords in `terraform.tfvars` or commit them to Git.

```bash
export TF_VAR_db_password="YourSecurePassword123!"
```

---

## Step 2 - Update terraform.tfvars

```hcl
aws_region   = "ap-south-1"
project_name = "three-tier"
key_name     = "your-key-pair-name"    # Must exist in AWS Console → EC2 → Key Pairs
ami_id       = "ami-0f58b397bc5c1f2e8" # Ubuntu 22.04 — ap-south-1
```

---

## Step 3 - Initialize Terraform

```bash
terraform init
```

---

## Step 4 - Validate and Plan

```bash
terraform validate
terraform plan
```

Expected from plan:

```
Plan: ~30 to add, 0 to change, 0 to destroy.

Resources:
  + aws_vpc.main
  + aws_subnet.public[0] / [1]
  + aws_subnet.private[0] / [1]
  + aws_subnet.database[0] / [1]
  + aws_internet_gateway.main
  + aws_nat_gateway.main
  + aws_eip.nat
  + aws_security_group.alb / .web / .app / .db
  + aws_instance.web[0] / [1]
  + aws_instance.app[0] / [1]
  + aws_lb.alb
  + aws_lb_target_group.web
  + aws_lb_target_group_attachment.web[0] / [1]
  + aws_lb_listener.http
  + aws_db_subnet_group.main
  + aws_db_instance.mysql
```

---

## Step 5 - Apply Infrastructure

```bash
terraform apply
```

Type `yes`. Takes approximately **10–15 minutes** (RDS provisioning is the slowest).

Expected outputs:

```
alb_dns_name     = "three-tier-alb-xxxxxxxxx.ap-south-1.elb.amazonaws.com"
rds_endpoint     = "three-tier-mysql.xxxxxxxxx.ap-south-1.rds.amazonaws.com:3306"
vpc_id           = "vpc-0abc123def456"
web_instance_ids = ["i-0abc123", "i-0def456"]
```

---

## Step 6 - Test the Architecture

Open the ALB DNS in your browser (wait ~3 minutes for instances to initialise):

```bash
curl http://$(terraform output -raw alb_dns_name)
```

Expected — ALB load-balances across both Web Tier instances:

```html
<h1>Web Tier - Instance 1</h1>
```

Refresh — you should see Instance 1 and Instance 2 alternating.

---

## Step 7 - Verify Network Isolation

In AWS Console, verify each Security Group only allows traffic from the tier above:

| Security Group | Inbound Rule | Source |
|----------------|--------------|--------|
| `alb-sg` | Port 80, 443 | `0.0.0.0/0` (internet) |
| `web-sg` | Port 80 | `alb-sg` only |
| `app-sg` | Port 8080 | `web-sg` only |
| `db-sg` | Port 3306 | `app-sg` only |

> ℹ️ This is **Security Group chaining** — a core AWS networking security pattern.

---

## Verification Checklist

✅ `terraform apply` — ~30 resources created

✅ ALB DNS accessible — returns Web Tier response

✅ ALB alternates between Instance 1 and Instance 2 (load balancing)

✅ Web Tier EC2 in public subnets (has public IP)

✅ App Tier EC2 in private subnets (no public IP)

✅ RDS in database subnets (no internet route)

✅ Each Security Group uses SG-reference (not CIDR) for tier-to-tier rules

---

## Troubleshooting

**ALB returns 502 Bad Gateway:**
- Web Tier instances may still be starting — wait 2–3 minutes for user-data (Nginx install) to complete
- Check Target Group health: AWS Console → EC2 → Target Groups → health checks

**`Error: InvalidParameterValue` on RDS:**
- Set `TF_VAR_db_password` before running apply
- Password must be 8+ characters

**App Tier instances can't reach internet:**
- Verify NAT Gateway is in a public subnet and its route table is attached to private subnets

---

## Cleanup

> ⚠️ This architecture runs ~$5–10/day (NAT Gateway + RDS + ALB). Always destroy when done.

```bash
terraform destroy
```

---

## Production Notes

> **1. Enable RDS Multi-AZ for High Availability**
> Set `multi_az = true` — RDS will maintain a standby replica in a second AZ for automatic failover.

> **2. Add HTTPS with ACM**
> Request an SSL certificate in ACM and add an HTTPS listener to the ALB. Redirect HTTP to HTTPS.

> **3. Use Auto Scaling Groups Instead of Fixed EC2**
> Replace `aws_instance` with `aws_autoscaling_group` + `aws_launch_template` so the Web and App tiers scale automatically based on CPU/request load.

> **4. Store terraform.tfstate Remotely**
> Use S3 + DynamoDB backend for state management in team environments.

---

## Key Learnings

- Three-tier architecture (Web / App / Database separation)
- Security Group chaining (SG-reference rules — not CIDR)
- Database subnet isolation (no internet route table)
- NAT Gateway for private subnet outbound internet
- ALB with Target Group and health checks
- `aws_lb_target_group_attachment` for EC2 registration
- RDS MySQL with `db_subnet_group` and version pinning
- `sensitive = true` for Terraform password variables
- `TF_VAR_` environment variable for secrets
- `count` meta-argument for multi-instance resources
- RDS Multi-AZ failover (production pattern)
- Auto Scaling Groups for dynamic compute scaling
