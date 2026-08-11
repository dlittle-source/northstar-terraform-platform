aws_region         = "us-east-1"
environment        = "dev"
vpc_cidr           = "10.20.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs      = ["10.20.0.0/24", "10.20.1.0/24"]
application_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]
database_subnet_cidrs    = ["10.20.20.0/24", "10.20.21.0/24"]

nat_gateway_mode        = "single"
flow_log_retention_days = 14