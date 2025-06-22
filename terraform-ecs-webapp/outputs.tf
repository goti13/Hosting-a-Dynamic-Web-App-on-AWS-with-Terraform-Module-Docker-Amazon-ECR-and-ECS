output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "ecs_service_name" {
  value = module.ecs.service_name
}
