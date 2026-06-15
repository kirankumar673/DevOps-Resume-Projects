aws_region   = "ap-south-1"
project_name = "enterprise-devsecops"

# VPC
vpc_cidr              = "10.0.0.0/16"
availability_zones    = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]

# Security — replace with your IP
# Run: curl ifconfig.me
admin_cidr = "YOUR_IP/32"

# EKS
kubernetes_version = "1.29"
node_instance_type = "t3.medium"
node_desired_size  = 2
node_min_size      = 1
node_max_size      = 4
