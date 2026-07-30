check "subnet_list_lengths_match" {
  assert {
    condition = (
      length(var.availability_zones) == length(var.public_subnet_cidrs) &&
      length(var.availability_zones) == length(var.application_subnet_cidrs) &&
      length(var.availability_zones) == length(var.database_subnet_cidrs)
    )
    error_message = "Each subnet CIDR list must contain exactly one CIDR per Availability Zone."
  }
}

check "subnets_are_unique" {
  assert {
    condition = length(distinct(concat(
      var.public_subnet_cidrs,
      var.application_subnet_cidrs,
      var.database_subnet_cidrs
      ))) == length(concat(
      var.public_subnet_cidrs,
      var.application_subnet_cidrs,
      var.database_subnet_cidrs
    ))
    error_message = "All public, application, and database subnet CIDR blocks must be unique."
  }
}
