# Resume Points — Project 10: Terraform AWS Infrastructure

---

## Fresher

- Provisioned a complete AWS network and compute stack (VPC, Subnet, Internet Gateway, Route Table, Security Group, EC2) using Terraform Infrastructure as Code.
- Used variable types and descriptions in `variables.tf` and separated environment values into `terraform.tfvars` for clean configuration management.
- Restricted SSH (port 22) in the Security Group to a specific IP via a variable (`ssh_allowed_cidr`) instead of opening to `0.0.0.0/0`.
- Added `egress` rules, resource tags, and `enable_dns_hostnames` to follow AWS and Terraform best practices.

---

## Experienced DevOps Engineer

- Designed a complete AWS infrastructure stack using Terraform with a full network layer: VPC with DNS support, public subnet with `map_public_ip_on_launch`, Internet Gateway, and Route Table association for public connectivity.
- Implemented production Terraform best practices: typed variables with descriptions, tagged all resources for cost allocation, separated concerns across `main.tf`, `variables.tf`, `outputs.tf`, and `terraform.tfvars`.
- Documented remote state management using S3 + DynamoDB backend and Terraform workspace strategy for multi-environment deployments.
- Used `terraform output -raw public_ip` to dynamically retrieve infrastructure values post-apply without manual lookups.

---

## LinkedIn Project Description

Provisioned a production-aligned AWS infrastructure stack using Terraform: VPC with DNS support, public subnet, Internet Gateway, Route Table, Security Group with SSH restricted to specific IP and egress rules, and tagged EC2 instance. Used typed Terraform variables, descriptive outputs, and `terraform.tfvars` for clean configuration separation. Documented remote state (S3 + DynamoDB), workspace-based multi-environment strategy, and `.gitignore` best practices for secrets management.

---

## GitHub Project Description

Terraform AWS Infrastructure — Full network + compute stack (VPC, Subnet, IGW, Route Table, Security Group, EC2) with typed variables, tagged resources, SSH-restricted security group, egress rules, descriptive outputs, and documented S3 remote state pattern.

---

## How to Explain in an Interview (30 Seconds)

"I used Terraform to provision a full AWS stack: VPC with DNS enabled, a public subnet, Internet Gateway and Route Table for internet access, a Security Group with SSH restricted to my IP and HTTP open, and an EC2 instance. I followed Terraform best practices — typed variables with descriptions, tagged every resource for cost visibility, used `terraform.tfvars` to separate config from code, and documented how to use an S3 backend for remote state — because storing `terraform.tfstate` locally breaks team collaboration."

---

## Skills Demonstrated

- Terraform (`init`, `validate`, `plan`, `apply`, `destroy`, `output`)
- HCL syntax (resource blocks, variable types, output blocks)
- AWS VPC (CIDR, DNS hostnames/support)
- AWS Subnet (`map_public_ip_on_launch`)
- AWS Internet Gateway + Route Table (public internet routing)
- AWS Security Group (ingress/egress rules, descriptions, IP restriction)
- AWS EC2 (key pair, instance type, subnet, security group)
- `variables.tf` (type, description, default values)
- `outputs.tf` (descriptive outputs, `terraform output -raw`)
- `terraform.tfvars` (environment separation)
- Resource tagging (Name, Project — cost allocation)
- Remote state with S3 + DynamoDB (production pattern)
- Terraform workspaces (multi-environment)
- `.gitignore` for `tfstate` and `tfvars` (secrets management)
