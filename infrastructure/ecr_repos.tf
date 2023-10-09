module "ecr_repos" {
  source       = "./core/resource-groups/ecr-repository-group"
  is_ephemeral = true
  repository_names = [
    "nginx",
    "uwsgi",
  ]
}
