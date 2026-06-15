variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu 22.04 in your region)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the existing EC2 Key Pair for SSH access"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "Your IP in CIDR notation for SSH access (e.g. 203.0.113.0/32)"
  type        = string
  default     = "0.0.0.0/0" # Restrict to your IP in production!
}
