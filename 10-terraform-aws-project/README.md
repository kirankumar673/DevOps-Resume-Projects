# Project 10 - Provision AWS Infrastructure Using Terraform

## Problem Statement

Your company wants to provision AWS infrastructure consistently and repeatably.

Current Problems:

- Manual resource creation via AWS Console — slow and error-prone
- No version control over infrastructure changes
- Difficult to replicate environments (dev/staging/prod)
- Risk of configuration drift

Build a solution using Terraform (Infrastructure as Code) to provision a complete AWS networking and compute stack.

---

## Architecture

```
Terraform (local)
      │
      ▼ terraform apply
AWS Cloud
      │
      ├── VPC (10.0.0.0/16)
      │     ├── Public Subnet (10.0.1.0/24)
      │     ├── Internet Gateway
      │     └── Route Table → IGW
      │
      ├── Security Group
      │     ├── Port 22 (SSH) ← Your IP only
      │     └── Port 80 (HTTP) ← Open
      │
      └── EC2 Instance (t2.micro, Ubuntu 22.04)
            └── In Public Subnet
```

---

## Project Structure

```
10-terraform-aws-project/
├── main.tf           ← All AWS resources (VPC, Subnet, SG, EC2, IGW, Route Table)
├── variables.tf      ← Input variable declarations with types and descriptions
├── outputs.tf        ← Output values (instance ID, public IP, VPC ID)
└── terraform.tfvars  ← Actual variable values (region, AMI, key pair name)
```

---

## Prerequisites

- AWS Account → [Sign up free](https://aws.amazon.com/free/)
- Terraform installed → [Install Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI installed → [Install AWS CLI](https://aws.amazon.com/cli/)
- An existing EC2 Key Pair (create in AWS Console → EC2 → Key Pairs)

Verify tools:

```bash
terraform version
aws --version
```

---

## Step 1 - Configure AWS CLI

```bash
aws configure
```

Enter when prompted:

| Prompt | Value |
|--------|-------|
| AWS Access Key ID | Your IAM user access key |
| AWS Secret Access Key | Your IAM user secret key |
| Default region | `ap-south-1` (or your region) |
| Default output format | `json` |

Verify credentials work:

```bash
aws sts get-caller-identity
```

Expected:

```json
{
  "UserId": "AIDA...",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/your-user"
}
```

---

## Step 2 - Review and Update terraform.tfvars

Open `terraform.tfvars` and update the values:

```hcl
aws_region = "ap-south-1"

# Ubuntu 22.04 LTS AMI for ap-south-1
# Find your region's AMI: https://cloud-images.ubuntu.com/locator/ec2/
ami_id = "ami-0f58b397bc5c1f2e8"

instance_type = "t2.micro"

# Name of your existing EC2 Key Pair
key_name = "my-key-pair"

# Restrict SSH to your IP: https://checkip.amazonaws.com/
ssh_allowed_cidr = "YOUR_IP/32"
```

> ⚠️ Never commit `terraform.tfvars` with real credentials to Git. Add it to `.gitignore`.

---

## Step 3 - Initialize Terraform

Download the AWS provider plugin:

```bash
terraform init
```

Expected:

```
Terraform has been successfully initialized!
```

---

## Step 4 - Validate Configuration

Check for syntax errors:

```bash
terraform validate
```

Expected:

```
Success! The configuration is valid.
```

---

## Step 5 - Review the Plan

See exactly what Terraform will create before touching AWS:

```bash
terraform plan
```

Expected — review the list of resources to be created:

```
Plan: 7 to add, 0 to change, 0 to destroy.

  + aws_vpc.main
  + aws_subnet.public
  + aws_internet_gateway.main
  + aws_route_table.public
  + aws_route_table_association.public
  + aws_security_group.web
  + aws_instance.web
```

---

## Step 6 - Apply and Create Infrastructure

```bash
terraform apply
```

Type `yes` when prompted:

```
Do you want to perform these actions?
  Enter a value: yes
```

Expected:

```
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

instance_id       = "i-0abc123def456"
public_ip         = "13.234.xx.xx"
public_dns        = "ec2-13-234-xx-xx.ap-south-1.compute.amazonaws.com"
vpc_id            = "vpc-0abc123def456"
subnet_id         = "subnet-0abc123def456"
security_group_id = "sg-0abc123def456"
```

---

## Step 7 - Verify Resources in AWS Console

1. Go to [AWS Console](https://console.aws.amazon.com)
2. Verify each resource:

| Resource | Where to check |
|----------|---------------|
| VPC | VPC → Your VPCs → `terraform-vpc` |
| Subnet | VPC → Subnets → `terraform-public-subnet` |
| Internet Gateway | VPC → Internet Gateways → `terraform-igw` |
| Security Group | EC2 → Security Groups → `terraform-web-sg` |
| EC2 Instance | EC2 → Instances → `terraform-web-server` (Running) |

---

## Step 8 - Connect to the EC2 Instance (Optional)

```bash
ssh -i your-key.pem ubuntu@$(terraform output -raw public_ip)
```

> ℹ️ `terraform output -raw public_ip` automatically reads the IP from Terraform state.

---

## Verification Checklist

✅ `terraform init` completed — `.terraform` folder created

✅ `terraform validate` — `Success! The configuration is valid.`

✅ `terraform plan` — shows 7 resources to create

✅ `terraform apply` — `Apply complete! Resources: 7 added`

✅ All outputs shown (public_ip, vpc_id, etc.)

✅ Resources visible and tagged in AWS Console

✅ EC2 instance in `Running` state

---

## Troubleshooting

**`Error: No valid credential sources found`**
- Run `aws configure` and ensure access key and secret key are correct
- Run `aws sts get-caller-identity` to test credentials

**`Error: InvalidAMIID.NotFound`**
- The AMI ID in `terraform.tfvars` is region-specific. Find the correct Ubuntu 22.04 AMI for your region at: https://cloud-images.ubuntu.com/locator/ec2/

**`Error: InvalidKeyPair.NotFound`**
- The `key_name` must match an existing Key Pair in AWS Console → EC2 → Key Pairs

---

## Cleanup

Destroy all resources created by Terraform:

```bash
terraform destroy
```

Type `yes` to confirm.

Expected:

```
Destroy complete! Resources: 7 destroyed.
```

> ⚠️ This permanently deletes all resources. Run `terraform plan -destroy` first to review what will be deleted.

---

## Production Notes

> **1. Store Terraform State Remotely**
> By default, `terraform.tfstate` is stored locally — dangerous for teams. Use S3 + DynamoDB for remote state:
> ```hcl
> terraform {
>   backend "s3" {
>     bucket         = "my-terraform-state"
>     key            = "project10/terraform.tfstate"
>     region         = "ap-south-1"
>     dynamodb_table = "terraform-lock"
>   }
> }
> ```

> **2. Use Terraform Workspaces for Multiple Environments**
> ```bash
> terraform workspace new staging
> terraform workspace new production
> ```

> **3. Never Commit `terraform.tfstate` or `terraform.tfvars` to Git**
> Add to `.gitignore`:
> ```
> *.tfstate
> *.tfstate.backup
> terraform.tfvars
> .terraform/
> ```

---

## Key Learnings

- Terraform workflow (`init` → `validate` → `plan` → `apply` → `destroy`)
- HCL (HashiCorp Configuration Language) syntax
- AWS VPC, Subnet, Internet Gateway, Route Table (full network stack)
- Security Group ingress/egress rules with descriptions
- EC2 instance provisioning with key pair and tags
- Variable types and descriptions (`variables.tf`)
- Output values (`outputs.tf`) — reading with `terraform output`
- `terraform.tfvars` for environment-specific values
- Terraform state file concept
- Remote state with S3 + DynamoDB (production pattern)
- Resource tagging for cost allocation
