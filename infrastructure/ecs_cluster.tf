module "ecs_cluster" {
  source = "./core/modules/ecs-cluster"

  cluster_name = "DMP15-POC"
  execution_role = {
    "arn"  = aws_iam_role.ecs_execution_role.arn,
    "name" = aws_iam_role.ecs_execution_role.name
  }
  execution_role_policy_docs = {
    "ecr" : module.ecr_repos.pull_repo_images_policy_document_json,
    "log" : data.aws_iam_policy_document.ecs_execution_log_permissions.json,
    "pass_task_role" : data.aws_iam_policy_document.ecs_execution_pass_task_role_permissions.json
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name        = "ecs-execution"
  description = "Role assumed by the ECS service during provision and setup of tasks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "ecs_execution_log_permissions" {
  # Note: We knowingly expect repeat "DescribeAllLogGroups" Sids, hence we use
  # `override_` rather than `source_`
  override_policy_documents = [
    module.web_task.write_task_logs_policy_document_json,
  ]
}

data "aws_iam_policy_document" "ecs_execution_pass_task_role_permissions" {
  source_policy_documents = [
    module.web_task.pass_task_role_policy_document_json,
  ]
}
