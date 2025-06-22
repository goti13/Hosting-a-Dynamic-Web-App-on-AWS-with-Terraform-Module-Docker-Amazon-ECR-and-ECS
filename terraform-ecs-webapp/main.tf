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
  region = "us-east-1" # change if needed
}

##############################
# ECR Module (from Task 2)
##############################

module "ecr" {
  source = "./modules/ecr"

  repository_name = "my-webapp-repo"
  tags = {
    Environment = "dev"
    Project     = "ecs-webapp"
  }
}

##############################
# ECS Module (from Task 3)
##############################

module "ecs" {
  source = "./modules/ecs"

  cluster_name       = "webapp-cluster"
  image_url          = module.ecr.repository_url # ECR image URL
  task_cpu           = "256"
  task_memory        = "512"
  desired_count      = 1
  subnet_ids         = module.network.public_subnet_ids
  security_group_id  = module.network.security_group_id
  
}

##############################
# Network Module
##############################

module "network" {
  source = "./modules/network"

  name                = "webapp"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                 = ["us-east-1a", "us-east-1b"] # Adjust to your region
}

