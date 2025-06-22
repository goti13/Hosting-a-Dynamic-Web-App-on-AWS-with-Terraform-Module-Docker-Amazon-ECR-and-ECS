output "cluster_id" {
  value = aws_ecs_cluster.Gerald_test_cluster.id
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.Gerald_test_task-definition.arn
}
