variable "name_prefix" {
  description = "Standard prefix applied to compute resource names."
  type        = string

  validation {
    condition     = length(trimspace(var.name_prefix)) >= 3
    error_message = "name_prefix must contain at least three characters."
  }
}

variable "application_subnet_ids" {
  description = "Private application subnet IDs available to the compute layer."
  type        = list(string)

  validation {
    condition     = length(var.application_subnet_ids) >= 1
    error_message = "Provide at least one private application subnet ID."
  }
}

variable "application_security_group_id" {
  description = "Security group ID assigned to application-tier EC2 instances."
  type        = string

  validation {
    condition     = length(trimspace(var.application_security_group_id)) > 0
    error_message = "application_security_group_id cannot be empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type used by the application server."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Size in GiB of the encrypted EC2 root volume."
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "common_tags" {
  description = "Standard tags applied to supported compute resources."
  type        = map(string)
  default     = {}
}