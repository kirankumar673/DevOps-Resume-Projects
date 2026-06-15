module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = "t2.micro"
}

module "alb" {
  source = "./modules/alb"
}

module "rds" {
  source = "./modules/rds"
}
