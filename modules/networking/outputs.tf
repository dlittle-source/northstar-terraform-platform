output "vpc_id" {
  description = "ID of the environment VPC."
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the environment VPC."
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "CIDR block assigned to the VPC."
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "availability_zones" {
  description = "Availability Zones used by the network."
  value       = var.availability_zones
}

output "public_subnet_ids" {
  description = "Public subnet IDs ordered by availability_zones."
  value       = [for az in var.availability_zones : aws_subnet.public[az].id]
}

output "application_subnet_ids" {
  description = "Private application subnet IDs ordered by availability_zones."
  value       = [for az in var.availability_zones : aws_subnet.application[az].id]
}

output "database_subnet_ids" {
  description = "Private database subnet IDs ordered by availability_zones."
  value       = [for az in var.availability_zones : aws_subnet.database[az].id]
}

output "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  value       = var.public_subnet_cidrs
}

output "application_subnet_cidrs" {
  description = "Private application subnet CIDR blocks."
  value       = var.application_subnet_cidrs
}

output "database_subnet_cidrs" {
  description = "Private database subnet CIDR blocks."
  value       = var.database_subnet_cidrs
}

output "nat_gateway_ids" {
  description = "Map of Availability Zone to NAT Gateway ID."
  value       = { for az, gateway in aws_nat_gateway.this : az => gateway.id }
}

output "public_route_table_id" {
  description = "ID of the shared public route table."
  value       = aws_route_table.public.id
}

output "application_route_table_ids" {
  description = "Map of Availability Zone to application route table ID."
  value       = { for az, table in aws_route_table.application : az => table.id }
}

output "database_route_table_ids" {
  description = "Map of Availability Zone to database route table ID."
  value       = { for az, table in aws_route_table.database : az => table.id }
}

output "flow_log_id" {
  description = "ID of the VPC Flow Log when enabled."
  value       = try(aws_flow_log.this[0].id, null)
}

output "flow_log_group_name" {
  description = "CloudWatch Logs group receiving VPC Flow Logs when enabled."
  value       = try(aws_cloudwatch_log_group.flow_logs[0].name, null)
}
