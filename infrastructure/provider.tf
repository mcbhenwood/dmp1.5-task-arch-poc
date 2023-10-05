terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ENVIRONMENT  = var.environment_name
      ORGANISATION = "CCS"
      PROJECT      = "DMP15POC"
    }
  }

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/cicd_infrastructure"
    session_name = "dmp15poc_cicd_infrastructure"
  }
}
