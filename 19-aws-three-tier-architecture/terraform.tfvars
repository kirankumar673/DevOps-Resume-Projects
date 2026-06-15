aws_region   = "ap-south-1"
project_name = "three-tier"

# VPC networking — 3 tiers across 2 AZs
vpc_cidr              = "10.0.0.0/16"
availability_zones    = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
database_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]

# Compute
# Ubuntu 22.04 LTS — ap-south-1
ami_id        = "ami-0f58b397bc5c1f2e8"
instance_type = "t2.micro"
key_name      = "my-key-pair"   # Replace with your EC2 Key Pair name

# Database
db_username = "admin"
# db_password — set via environment variable (never commit to Git):
# export TF_VAR_db_password="YourSecurePassword123!"
