locals {
  name_prefix = var.name_prefix

  security_tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "Security"
    }
  )
}