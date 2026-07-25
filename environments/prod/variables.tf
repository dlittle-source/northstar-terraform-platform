variable "aws_region" {
  description = "AWS Region where the environment is deployed."
  type        = string
  default     = "us-east-1"
}

variable "company_name" {
  description = "Company that owns the platform."
  type        = string
  default     = "Northstar Freight Systems"
}

variable "project_name" {
  description = "Human-readable project name."
  type        = string
  default     = "Northstar Operations Portal"
}

variable "application_name" {
  description = "Short application identifier used in resource names."
  type        = string
  default     = "portal"
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "owner" {
  description = "Team responsible for the platform."
  type        = string
  default     = "Cloud Platform Engineering"
}

variable "repository_name" {
  description = "GitHub repository containing the configuration."
  type        = string
  default     = "northstar-terraform-platform"
}

variable "cost_center" {
  description = "Organizational cost center."
  type        = string
  default     = "Platform-Engineering"
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the environment VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the environment."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
}

variable "application_subnet_cidrs" {
  description = "Private application subnet CIDR blocks."
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "Private database subnet CIDR blocks."
  type        = list(string)
}

variable "nat_gateway_mode" {
  description = "single for development cost control or one_per_az for production resilience."
  type        = string
}

variable "flow_log_retention_days" {
  description = "CloudWatch retention period for VPC Flow Logs."
  type        = number
}
