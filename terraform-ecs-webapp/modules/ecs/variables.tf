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
