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

output "alb_dns_name" {
  description = "Public DNS name of the NorthStar Application Load Balancer."
  value       = module.application_delivery.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the NorthStar Application Load Balancer."
  value       = module.application_delivery.alb_arn
}

output "target_group_arn" {
  description = "ARN of the NorthStar application target group."
  value       = module.application_delivery.target_group_arn
}
