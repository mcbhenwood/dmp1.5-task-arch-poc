module "web_task" {
  source = "./core/resource-groups/ecs-fargate-task-definition"

  aws_account_id        = var.aws_account_id
  aws_region            = var.aws_region
  container_definitions = {
    nginx = {
      cpu                          = 2048
      environment_variables        = []
      essential                    = true
      healthcheck_command          = "curl -f http://localhost:8080/ || exit 1"
      image                        = module.ecr_repos.repository_urls["nginx"]
      memory                       = 2048
      mounts                       = []
      override_command             = null
      port                         = 8080
      secret_environment_variables = []
    }
    uwsgi = {
      cpu                          = 2048
      environment_variables        = []
      essential                    = true
      healthcheck_command          = "curl -f http://localhost:8888/ || exit 1"
      image                        = module.ecr_repos.repository_urls["uwsgi"]
      memory                       = 8192
      mounts                       = []
      override_command             = null
      port                         = 8888
      secret_environment_variables = []
    }
  }
  ecs_execution_role_arn = aws_iam_role.ecs_execution_role.arn
  family_name            = "poc"
  task_cpu               = 4096
  task_memory            = 10240
}

resource "aws_ecs_service" "web" {
  cluster              = module.ecs_cluster.cluster_arn
  desired_count        = 1
  force_new_deployment = false
  launch_type          = "FARGATE"
  name                 = "web"
  task_definition      = module.web_task.task_definition_arn

  network_configuration {
    assign_public_ip = true
    security_groups  = [
      aws_security_group.web_tasks.id,
    ]
    subnets = module.vpc.subnets.public.ids
  }

  lifecycle {
    # Don't kill scaled services every time we apply Terraform
    ignore_changes = [
      desired_count
    ]
  }
}
