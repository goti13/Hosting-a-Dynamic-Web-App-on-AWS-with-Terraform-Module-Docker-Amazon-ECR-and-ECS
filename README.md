# Hosting-a-Dynamic-Web-App-on-AWS-with-Terraform-Module-Docker-Amazon-ECR-and-ECS

Project Purpose:

The purpose of this project is to use Terraform to create a modular infrastructure for hosting a dynamic web application on Amazon ECS (Elastic Container Service). The project involves containerizing the web app using Docker, pushing the Docker image to Amazon ECR (Elastic Container Registry), and deploying the app on ECS.

Project Tasks:

Task 1: Dockerization of Web App

1. ﻿﻿﻿Create a dynamic web application using a technology of your choice (e.g., Node.js, Flask, Django).
2. ﻿﻿﻿Write a 'Dockerfile' to containerize the web application.
3. ﻿﻿﻿Test the Docker image locally to ensure the web app runs successfully within a container.

Create a docker file

```
# Use the official NGINX image as the base image
FROM nginx:latest

# Set the working directory in the container
WORKDIR /usr/share/nginx/html/

# Copy all files and directories from the local repository to the working directory
COPY . .

# Expose port 80 to allow external access
EXPOSE 80

```

![image](https://github.com/user-attachments/assets/c7091872-8840-488d-9e6d-db8a7b9cd83c)


![image](https://github.com/user-attachments/assets/a96acf64-9701-4e1c-876e-c454138acadd)


Task 2: Terraform Module for Amazon ECR
1. ﻿﻿﻿Create a new directory for your Terraform project (e.g., ' terraform-ecs-webapp*).
2. ﻿﻿﻿Inside the project directory, create a directory for the Amazon ECR module (e.g., 'modules/ecr').
3. ﻿﻿﻿Write a Terraform module ('modules/ecr/main.tf') to create an Amazon ECR repository for storing Docker images.

Task 3: Terraform Module for ECS
1. ﻿﻿﻿Inside the project directory, create a directory for the ECS module (e.g., 'modules/ecs*).
2. ﻿﻿﻿Write a Terraform module ('modules/ecs/main.tf') to provision an ECS cluster and deploy the Dockerized web app.

Task 4: Main Terraform Configuration
1. ﻿﻿﻿Create the main Terraform configuration file ('main. tf') in the project directory.
2. ﻿﻿﻿Use the ECR and ECS modules to create the necessary infrastructure for hosting the web app.

Task 5: Deployment
1. ﻿﻿﻿Build the Docker image of your web app.
2. ﻿﻿﻿Push the Docker image to the Amazon ECR repository created by Terraform.
3. ﻿﻿﻿Run 'terraform init' and 'terraform apply' to deploy the ECS cluster and the web app.

Instructions:
1. ﻿﻿﻿Create a new directory for your Terraform project using a terminal ("mkdir terraform-ecs-webapp*).
2. ﻿﻿﻿Change into the project directory ('cd terraform-ecs-webapp').
3. ﻿﻿﻿Create directories for the ECR and ECS modules ('mkdir -p modules/ecr' and mkdir -p modules/ecs').
4. ﻿﻿﻿Write the ECR module configuration (' nano modules/ecr/main.tf*) to create an ECR repository.
5. ﻿﻿﻿Write the ECS module configuration ('nano modules/ecs/main.tf') to provision an ECS cluster and deploy the Dockerized web app.
6. ﻿﻿﻿Create the main Terraform configuration file ('nano main.tf') and use the ECR and ECS modules.
module "ecr" {"\n source = \"'-/modules/ecr\"\n repository_name = \"your-webapp-repo\"\n"}
module "ecs" {"\n source = \"'•/modules/ecs\"\n ecr_repository_url = module.ecr.repository_url\n // Add other variables as needed\n"}
1. ﻿﻿﻿Build the Docker image of your web app and push it to the ECR repository.
2. ﻿﻿﻿Run 'terraform init' and 'terraform apply' to deploy the ECS cluster and the web app.
3. ﻿﻿﻿Access the web app through the public IP or DNS of the ECS service.
4. ﻿﻿﻿﻿Document your observations and any challenges faced during the project.
###################################
IMPLEMENTATION
###################################

# Directory Structure

terraform-ecs-webapp/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── ecr/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecs/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── network/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf


# main.tf 

```
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

```

# outputs.tf file

```
output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

```
# variables.tf file

```

```

# modules/ecr/main.tf  file

```

resource "aws_ecr_repository" "Gerald_test_ecr" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.Gerald_test_ecr.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 14 days"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 14
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only last 10 images with tag 'release'"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["release"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}


```
# modules/ecr/outputs.tf file

```

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.Gerald_test_ecr.repository_url
}

output "repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.Gerald_test_ecr.name
}


```

# modules/ecr/variables.tf file

```
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

```


# modules/ecs/main.tf file

```
resource "aws_ecs_cluster" "Gerald_test_cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.cluster_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "Gerald_test_task-definition" {
  family                   = "${var.cluster_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  

  container_definitions = jsonencode([
    {
      name      = "webapp"
      image     = var.image_url
      essential = true
      assign_public_ip = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.Gerald_test_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.Gerald_test_task-definition.arn
  desired_count   = var.desired_count

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy]
}


```

# modules/ecs/variables.tf file

```
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "image_url" {
  description = "Docker image URL (e.g. from ECR)"
  type        = string
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Fargate task memory (MB)"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Number of ECS service tasks"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the ECS tasks"
  type        = string
}


```

# modules/ecs/outputs.tf file


```
output "cluster_id" {
  value = aws_ecs_cluster.Gerald_test_cluster.id
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.Gerald_test_task-definition.arn
}


```

# modules/network/main.tf file


```
resource "aws_vpc" "Gerald_test_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.Gerald_test_vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.Gerald_test_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Gerald_test_vpc.id
  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.name}-ecs-sg"
  description = "Allow inbound HTTP/HTTPS"
  vpc_id      = aws_vpc.Gerald_test_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}


```


# modules/network.variables.tf file

```
variable "name" {
  description = "Prefix name for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}


```

modules/network.outputs.tf file


```

output "vpc_id" {
  value = aws_vpc.Gerald_test_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}


```

![image](https://github.com/user-attachments/assets/8436e79b-c784-4aaf-8cd3-74fb3c073ad9)

![image](https://github.com/user-attachments/assets/849f82c6-312e-48a6-bc68-d6702f2cc099)

![image](https://github.com/user-attachments/assets/1eac1e2c-a62a-4a2f-81a5-41d393067d03)


![image](https://github.com/user-attachments/assets/7ec79060-b73c-4363-880c-6aaa057300fd)


![image](https://github.com/user-attachments/assets/0ef4d785-a681-4c45-ab99-299e556882c4)

![image](https://github.com/user-attachments/assets/3acca3fd-4835-4a3d-af2c-315c659a6844)


🚀 Task 5: Deployment


Step 1: 

```
# Log in to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.us-east-1.amazonaws.com


# Tag the image with your ECR repo URL (replace with actual output from Terraform)
docker tag my-webapp:latest <your-ecr-url>:latest


```

![image](https://github.com/user-attachments/assets/5452de51-750f-4efb-bf9a-df01399bed20)

![image](https://github.com/user-attachments/assets/42bcfe53-6125-4d9f-b03b-4906ca7c5757)


![image](https://github.com/user-attachments/assets/576c56e7-72ce-46bb-bdd4-0858047ab928)




Step 2: Push the Image to ECR

```
docker push <your-ecr-url>:latest

```
![image](https://github.com/user-attachments/assets/0e87c1a6-c8c7-4051-92c7-366c5c82f7ed)


<img width="1390" alt="image" src="https://github.com/user-attachments/assets/068cde96-e3cd-4a0c-8346-090dd8d78185" />


<img width="1399" alt="image" src="https://github.com/user-attachments/assets/5d272bdb-539d-4680-bb91-0ae53f7c57c4" />


# CLEAN UP


🧹 1. Delete Docker Images (Local)

```
docker rmi 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-webapp-repo:latest

```
2. Delete Local Image

```
docker rmi myapp:latest

```

3. Destroy All Terraform Infrastructure

```

terraform destroy -auto-approve

```

![image](https://github.com/user-attachments/assets/df3eed34-826d-4623-bc53-21dc784e4649)


![image](https://github.com/user-attachments/assets/990a28a9-a702-4bd6-b862-8bf603ed21b5)













