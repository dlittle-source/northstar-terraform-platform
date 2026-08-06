locals {
  tags = merge(var.common_tags, {
    Module    = "compute"
    ManagedBy = "Terraform"
  })
}