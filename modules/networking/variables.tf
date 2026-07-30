variable "name_prefix" {
  description = "Standard prefix applied to networking resource names."
  type        = string

  validation {
    condition     = length(trimspace(var.name_prefix)) >= 3
    error_message = "name_prefix must contain at least three characters."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used by the environment."
  type        = list(string)

  validation {
    condition = (
      length(var.availability_zones) >= 2 &&
      length(distinct(var.availability_zones)) == length(var.availability_zones)
    )

    error_message = "Provide at least two unique Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, ordered to match availability_zones."
  type        = list(string)

  validation {
    condition = (
      length(var.public_subnet_cidrs) == length(var.availability_zones) &&
      alltrue([
        for cidr in var.public_subnet_cidrs :
        can(cidrnetmask(cidr))
      ])
    )

    error_message = "public_subnet_cidrs must contain one valid CIDR for each Availability Zone."
  }
}

variable "application_subnet_cidrs" {
  description = "CIDR blocks for private application subnets, ordered to match availability_zones."
  type        = list(string)

  validation {
    condition = (
      length(var.application_subnet_cidrs) == length(var.availability_zones) &&
      alltrue([
        for cidr in var.application_subnet_cidrs :
        can(cidrnetmask(cidr))
      ])
    )

    error_message = "application_subnet_cidrs must contain one valid CIDR for each Availability Zone."
  }
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for isolated database subnets, ordered to match availability_zones."
  type        = list(string)

  validation {
    condition = (
      length(var.database_subnet_cidrs) == length(var.availability_zones) &&
      alltrue([
        for cidr in var.database_subnet_cidrs :
        can(cidrnetmask(cidr))
      ])
    )

    error_message = "database_subnet_cidrs must contain one valid CIDR for each Availability Zone."
  }
}

variable "nat_gateway_mode" {
  description = "NAT design: single creates one NAT Gateway; one_per_az creates a NAT Gateway in every Availability Zone."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "one_per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single or one_per_az."
  }
}

variable "enable_vpc_flow_logs" {
  description = "Whether to publish VPC Flow Logs to CloudWatch Logs."
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "CloudWatch retention period for VPC Flow Logs."
  type        = number
  default     = 30

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180,
      365, 400, 545, 731, 1096, 1827, 2192, 2557,
      2922, 3288, 3653
    ], var.flow_log_retention_days)

    error_message = "flow_log_retention_days must be a CloudWatch Logs-supported retention value."
  }
}

variable "flow_log_traffic_type" {
  description = "Traffic recorded by VPC Flow Logs."
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "flow_log_traffic_type must be ACCEPT, REJECT, or ALL."
  }
}

variable "common_tags" {
  description = "Standard tags applied to all supported resources."
  type        = map(string)
  default     = {}
}