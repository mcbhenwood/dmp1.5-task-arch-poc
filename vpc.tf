module "vpc" {
  source = "./core/modules/four-tier-vpc"

  aws_region             = var.aws_region
  database_ports         = []
  resource_name_prefixes = var.resource_name_prefixes
  vpc_cidr_block         = "10.12.1.0/24"
}
