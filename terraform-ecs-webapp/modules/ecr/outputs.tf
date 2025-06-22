output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.Gerald_test_ecr.repository_url
}

output "repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.Gerald_test_ecr.name
}
