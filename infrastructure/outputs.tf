output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster in which the services will run"
  value       = module.ecs_cluster.cluster_arn
}
