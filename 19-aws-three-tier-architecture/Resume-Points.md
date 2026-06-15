# Resume Points — Project 19: AWS Three-Tier Architecture

---

## Fresher

- Deployed a production-style three-tier AWS architecture using Terraform: ALB (public), Web Tier EC2 × 2 (public subnets), App Tier EC2 × 2 (private subnets), and RDS MySQL (isolated database subnets with no internet route).
- Implemented Security Group chaining — each tier's SG only allows traffic from the SG directly above it (not CIDR ranges), so the database has zero internet exposure.
- Used `sensitive = true` for RDS password variables and `TF_VAR_db_password` environment variable pattern — never storing credentials in `terraform.tfvars` or Git.
- Configured ALB with a Target Group, health checks, and listener — traffic automatically distributes across both Web Tier instances.

---

## Experienced DevOps Engineer

- Designed a fully isolated three-tier network: public subnets for Web Tier and ALB (internet-facing), private subnets for App Tier (NAT Gateway for outbound), and dedicated database subnets with no route to internet — enforcing the principle of least-privilege at the network layer.
- Implemented Security Group chaining using SG references instead of CIDR blocks — Web Tier SG only accepts from ALB SG, App Tier only from Web Tier SG, DB SG only from App Tier SG — standard AWS security best practice.
- Used `count` meta-argument with subnet indexing for multi-AZ deployment of EC2 instances and subnets, `aws_lb_target_group_attachment` for ALB registration, and `aws_db_subnet_group` for RDS network isolation.
- Documented production upgrade paths: RDS `multi_az = true` for automatic failover, HTTPS ALB listener with ACM certificate, Auto Scaling Groups for dynamic scaling, and S3 remote state.

---

## LinkedIn Project Description

Provisioned a production three-tier AWS architecture using Terraform: ALB in public subnets distributing traffic to Web Tier EC2 × 2, App Tier EC2 × 2 in private subnets with NAT Gateway egress, and RDS MySQL in isolated database subnets with no internet route. Implemented Security Group chaining (SG-reference rules not CIDR) for zero internet exposure of database. Used `sensitive` Terraform variables + `TF_VAR_` environment variable pattern for credential security. Documented RDS Multi-AZ, HTTPS/ACM, Auto Scaling Groups, and S3 remote state as production patterns.

---

## GitHub Project Description

Terraform AWS Three-Tier Architecture — ALB + Web Tier EC2 (public) + App Tier EC2 (private + NAT) + RDS MySQL (isolated DB subnets). Security Group chaining with SG references. Typed variables, sensitive password handling via TF_VAR_, descriptive outputs, and documented Multi-AZ + Auto Scaling production upgrade paths.

---

## How to Explain in an Interview (30 Seconds)

"I deployed a three-tier AWS architecture using Terraform. The key security design is that each tier is isolated — Web Tier and ALB are in public subnets, App Tier is in private subnets with a NAT Gateway for outbound traffic, and the database is in completely isolated subnets with no internet route at all. The Security Groups use SG references instead of CIDR blocks — the database SG only allows port 3306 from the App Tier SG specifically. I also handled the RDS password using a `sensitive` Terraform variable set via `TF_VAR_db_password` environment variable — never in `terraform.tfvars` or committed to Git."

---

## Skills Demonstrated

- Three-tier architecture (Web / App / Database network isolation)
- Security Group chaining (SG-reference rules — production security pattern)
- Database subnet isolation (no internet route table)
- NAT Gateway for private subnet outbound internet
- AWS ALB with Target Group, health checks, HTTP listener
- `aws_lb_target_group_attachment` (EC2 registration to ALB)
- `aws_db_subnet_group` + RDS MySQL with engine version pinning
- `sensitive = true` Terraform variable (credential security)
- `TF_VAR_` environment variable pattern (secrets management)
- `count` meta-argument for multi-AZ resources
- `required_providers` with pinned AWS provider version
- Typed variables with descriptions and defaults
- RDS Multi-AZ for automatic failover (production pattern)
- Auto Scaling Groups (dynamic compute scaling)
- HTTPS ALB listener with ACM (production HTTPS)
