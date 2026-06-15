aws_region = "ap-south-1"

# Ubuntu 22.04 LTS AMI for ap-south-1 (Mumbai)
# Find your region's AMI: https://cloud-images.ubuntu.com/locator/ec2/
ami_id = "ami-0f58b397bc5c1f2e8"

instance_type = "t2.micro"

# Name of your existing EC2 Key Pair (create in AWS Console → EC2 → Key Pairs)
key_name = "my-key-pair"

# Restrict SSH to your IP — find it at https://checkip.amazonaws.com/
ssh_allowed_cidr = "0.0.0.0/0"  # Replace with YOUR_IP/32 in production
