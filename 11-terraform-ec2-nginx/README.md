# Project 11 - Provision and Configure an EC2 Web Server Using Terraform

## Problem Statement

Your company wants a web server to be created and configured automatically without any manual steps.

Current Problems:

- Manual EC2 creation via AWS Console
- Manual SSH login and Nginx installation
- Inconsistent server configuration across environments
- Time-consuming and error-prone setup

Build a solution using Terraform that creates the EC2 instance AND installs and configures Nginx automatically using a `user_data` bootstrap script — zero manual steps required.

---

## Architecture

```
Developer
    │
    ▼ terraform apply
Terraform
    │
    ├── Creates: Security Group (HTTP 80, SSH 22)
    │
    └── Creates: EC2 Instance
              │
              ▼ Runs automatically on first boot
          user-data.sh
              │
              ├── apt-get update && upgrade
              ├── apt-get install nginx
              ├── systemctl enable && start nginx
              └── Writes index.html to /var/www/html/
              │
              ▼
User opens http://PUBLIC_IP → "Hello From Terraform"
```

---

## Project Structure

```
11-terraform-ec2-nginx/
├── main.tf           ← Security Group + EC2 with user_data
├── variables.tf      ← Typed variables with descriptions
├── outputs.tf        ← Public IP output
├── terraform.tfvars  ← Region, AMI, key pair values
└── user-data.sh      ← Bootstrap script (Nginx install + deploy website)
```

---

## Prerequisites

- AWS Account → [Sign up free](https://aws.amazon.com/free/)
- Terraform installed → [Install Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI installed and configured → [Install AWS CLI](https://aws.amazon.com/cli/)
- An existing EC2 Key Pair (AWS Console → EC2 → Key Pairs → Create)

Verify tools:

```bash
terraform version
aws sts get-caller-identity
```

---

## Step 1 - Configure AWS CLI (if not done)

```bash
aws configure
```

Verify:

```bash
aws sts get-caller-identity
```

---

## Step 2 - Review and Update terraform.tfvars

Open `terraform.tfvars` and set your values:

```hcl
aws_region = "ap-south-1"

# Ubuntu 22.04 LTS AMI for ap-south-1
# Find your AMI: https://cloud-images.ubuntu.com/locator/ec2/
ami_id = "ami-0f58b397bc5c1f2e8"

instance_type = "t2.micro"

# Name of your EC2 Key Pair in AWS Console
key_name = "my-key-pair"

# Your IP for SSH access: https://checkip.amazonaws.com/
ssh_allowed_cidr = "YOUR_IP/32"
```

---

## Step 3 - Review the user-data.sh Script

This script runs automatically when EC2 first boots:

```bash
#!/bin/bash
set -e                                          # Exit on any error
exec > /var/log/user-data.log 2>&1             # Log everything

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
...
  <h1>Hello From Terraform</h1>
  <p>Provisioned automatically via Terraform user-data</p>
...
EOF
```

> ℹ️ Key improvements:
> - `set -e` — script stops immediately if any command fails
> - Logging to `/var/log/user-data.log` — you can SSH in and check if it ran correctly
> - `DEBIAN_FRONTEND=noninteractive` — prevents apt from hanging on prompts
> - Proper HTML5 page with `lang`, `charset`, `viewport`

---

## Step 4 - Initialize Terraform

```bash
terraform init
```

Expected:

```
Terraform has been successfully initialized!
```

---

## Step 5 - Validate and Plan

```bash
terraform validate
terraform plan
```

Expected from plan:

```
Plan: 2 to add, 0 to change, 0 to destroy.

  + aws_security_group.web
  + aws_instance.web
```

---

## Step 6 - Apply Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

Expected:

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_ip = "13.234.xx.xx"
```

---

## Step 7 - Wait for User Data to Complete

The `user-data.sh` script runs in the background after EC2 boots. Wait approximately **2-3 minutes** for Nginx to install and start.

You can monitor the script's progress by SSH-ing in and checking the log:

```bash
ssh -i your-key.pem ubuntu@$(terraform output -raw public_ip)
tail -f /var/log/user-data.log
```

Look for:

```
=== user-data script completed successfully ===
```

---

## Step 8 - Access the Website

Get the public IP:

```bash
terraform output public_ip
```

Open in your browser:

```
http://PUBLIC_IP
```

Or test with curl:

```bash
curl http://$(terraform output -raw public_ip)
```

Expected:

```html
Hello From Terraform
EC2 instance provisioned and configured automatically via Terraform user-data
```

---

## Verification Checklist

✅ `terraform init` successful

✅ `terraform validate` — `Success!`

✅ `terraform plan` — 2 resources to create

✅ `terraform apply` — `Apply complete! Resources: 2 added`

✅ EC2 instance in `Running` state in AWS Console

✅ `/var/log/user-data.log` shows `completed successfully`

✅ Website accessible at `http://PUBLIC_IP`

✅ `terraform output public_ip` returns the correct IP

---

## Troubleshooting

**Website not showing after apply:**
- Wait 2-3 minutes — user-data runs after boot
- SSH in and check: `tail -f /var/log/user-data.log`
- Check Nginx is running: `systemctl status nginx`

**SSH connection refused:**
- Confirm `ssh_allowed_cidr` is set to your IP (`YOUR_IP/32`)
- Confirm `key_name` matches an existing Key Pair in your AWS region

**`Error: InvalidAMIID.NotFound`:**
- AMI IDs are region-specific. Find Ubuntu 22.04 for your region: https://cloud-images.ubuntu.com/locator/ec2/

---

## Cleanup

```bash
terraform destroy
```

Type `yes` to confirm. All AWS resources will be deleted.

---

## Production Notes

> **1. Add Remote State Backend**
> Store `terraform.tfstate` in S3 with DynamoDB locking — never store state locally in teams:
> ```hcl
> terraform {
>   backend "s3" {
>     bucket         = "my-tfstate-bucket"
>     key            = "project11/terraform.tfstate"
>     region         = "ap-south-1"
>     dynamodb_table = "terraform-lock"
>   }
> }
> ```

> **2. Replace user-data with Ansible or AWS Systems Manager**
> For complex configurations, `user-data` becomes hard to maintain. Use Ansible playbooks or AWS Systems Manager Run Command for idempotent, repeatable server configuration.

> **3. Add Elastic IP**
> The EC2 public IP changes on stop/start. Use `aws_eip` in Terraform for a permanent IP.

---

## Key Learnings

- Terraform `user_data` (EC2 bootstrap automation)
- `file()` function in Terraform (read external script)
- `set -e` in bash scripts (fail-fast on error)
- `DEBIAN_FRONTEND=noninteractive` (non-interactive apt installs)
- User-data logging to `/var/log/user-data.log`
- `terraform output -raw` (use output values in shell commands)
- Security Group with egress rules and SSH IP restriction
- Tagged AWS resources for cost management
- Remote state with S3 + DynamoDB (production pattern)
- Ansible/SSM as user-data alternatives for complex configs
