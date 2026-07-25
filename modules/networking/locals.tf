locals {
  az_count = length(var.availability_zones)

  public_subnets = {
    for index, az in var.availability_zones : az => {
      cidr = var.public_subnet_cidrs[index]
      index = index
    }
  }

  application_subnets = {
    for index, az in var.availability_zones : az => {
      cidr = var.application_subnet_cidrs[index]
      index = index
    }
  }

  database_subnets = {
    for index, az in var.availability_zones : az => {
      cidr = var.database_subnet_cidrs[index]
      index = index
    }
  }

  nat_gateway_azs = var.nat_gateway_mode == "one_per_az" ? toset(var.availability_zones) : toset([var.availability_zones[0]])

  tags = merge(var.common_tags, {
    Module    = "networking"
    ManagedBy = "Terraform"
  })
}
