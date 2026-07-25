output "vpc_id" {
  description = "ID of the environment VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.networking.public_subnet_ids
}

output "application_subnet_ids" {
  description = "Private application subnet IDs."
  value       = module.networking.application_subnet_ids
}

output "database_subnet_ids" {
  description = "Private database subnet IDs."
  value       = module.networking.database_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs by Availability Zone."
  value       = module.networking.nat_gateway_ids
}

output "flow_log_group_name" {
  description = "CloudWatch Logs group receiving VPC Flow Logs."
  value       = module.networking.flow_log_group_name
}
