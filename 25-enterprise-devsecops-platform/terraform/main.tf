terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ── Module: VPC ──────────────────────────────────────────
module "vpc" {
  source               = "./vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# ── Module: Security Groups ──────────────────────────────
module "security_groups" {
  source       = "./security-groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  admin_cidr   = var.admin_cidr
}

# ── Module: EKS ──────────────────────────────────────────
module "eks" {
  source             = "./eks"
  project_name       = var.project_name
  kubernetes_version = var.kubernetes_version
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_nodes_sg_id    = module.security_groups.eks_nodes_sg_id
  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
}

# ── Module: ALB ──────────────────────────────────────────
module "alb" {
  source           = "./alb"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id        = module.security_groups.alb_sg_id
}
