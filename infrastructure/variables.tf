variable "aws_account_id" {
  type        = string
  description = "AWS account into which to deploy resources"
}

variable "aws_region" {
  type        = string
  description = "Region into which to deploy region-specific resources"
}

variable "environment_name" {
  type        = string
  description = "Name for this environment, to distinguish it from other environments for this system / application"
}

variable "resource_name_prefixes" {
  type = object({
    normal        = string,
    hyphens       = string,
    hyphens_lower = string
  })
  description = "Prefix to apply to resources in AWS; options provided to satisfy divergent naming requirements across AWS"
}
