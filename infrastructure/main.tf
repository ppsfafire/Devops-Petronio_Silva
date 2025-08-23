terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "devops-petronio-silva-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC e Subnets
module "vpc" {
  source = "./modules/vpc"
  
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = var.availability_zones
}

# ECR Repositories
module "ecr" {
  source = "./modules/ecr"
  
  environment = var.environment
  repository_names = [
    "devops-petronio-silva-backend",
    "devops-petronio-silva-frontend"
  ]
}

# ECS Cluster
module "ecs" {
  source = "./modules/ecs"
  
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  subnets     = module.vpc.private_subnets
  
  backend_image = module.ecr.backend_repository_url
  frontend_image = module.ecr.frontend_repository_url
}

# Application Load Balancer
module "alb" {
  source = "./modules/alb"
  
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  subnets     = module.vpc.public_subnets
}

# Outputs
output "alb_dns_name" {
  description = "DNS name do ALB"
  value       = module.alb.alb_dns_name
}

output "ecr_backend_url" {
  description = "URL do repositório ECR do backend"
  value       = module.ecr.backend_repository_url
}

output "ecr_frontend_url" {
  description = "URL do repositório ECR do frontend"
  value       = module.ecr.frontend_repository_url
}

output "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  value       = module.ecs.cluster_name
}
