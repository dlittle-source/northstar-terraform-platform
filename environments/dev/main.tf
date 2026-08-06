locals {
  company_short_name = "northstar"
  name_prefix        = "${local.company_short_name}-${var.application_name}-${var.environment}"

  common_tags = {
    Project       = var.project_name
    Company       = var.company_name
    Application   = var.application_name
    Environment   = var.environment
    ManagedBy     = "Terraform"
    Owner         = var.owner
    Repository    = var.repository_name
    CostCenter    = var.cost_center
    DataClass     = "Internal"
    BusinessUnit  = "Digital Operations"
    TerraformRoot = "environments/${var.environment}"
  }
}

module "networking" {
  source = "../../modules/networking"

  name_prefix              = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  application_subnet_cidrs = var.application_subnet_cidrs
  database_subnet_cidrs    = var.database_subnet_cidrs
  nat_gateway_mode         = var.nat_gateway_mode
  enable_vpc_flow_logs     = true
  flow_log_retention_days  = var.flow_log_retention_days
  flow_log_traffic_type    = "ALL"
  common_tags              = local.common_tags
}

module "security" {
  source = "../../modules/security"

  name_prefix  = local.name_prefix
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  common_tags  = local.common_tags

  cloudtrail_log_retention_days = 365
  cloudtrail_s3_expiration_days = 365
  enable_key_rotation           = true

  depends_on = [
    module.networking
  ]
}

module "compute" {
  source = "../../modules/compute"

  name_prefix                   = local.name_prefix
  application_subnet_ids        = module.networking.application_subnet_ids
  application_security_group_id = module.security.application_security_group_id
  instance_type                 = "t3.micro"
  root_volume_size              = 20
  common_tags                   = local.common_tags

  depends_on = [
    module.networking,
    module.security
  ]
}