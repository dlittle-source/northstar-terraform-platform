variable "name_prefix" {
  description = "Standardized resource name prefix supplied by the environment."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "The name prefix may contain only lowercase letters, numbers, and hyphens."
  }
}

variable "project_name" {
  description = "Name of the platform project."
  type        = string

  validation {
    condition     = length(trimspace(var.project_name)) >= 3
    error_message = "The project name must contain at least three characters."
  }
}

variable "environment" {
  description = "Deployment environment, such as dev, test, or prod."
  type        = string

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "The environment must be dev, test, stage, or prod."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "The VPC ID must be a valid AWS VPC identifier."
  }
}

variable "cloudtrail_log_retention_days" {
  description = "Number of days CloudTrail logs remain in CloudWatch Logs."
  type        = number
  default     = 365

  validation {
    condition = contains(
      [
        1,
        3,
        5,
        7,
        14,
        30,
        60,
        90,
        120,
        150,
        180,
        365,
        400,
        545,
        731,
        1096,
        1827,
        2192,
        2557,
        2922,
        3288,
        3653
      ],
      var.cloudtrail_log_retention_days
    )

    error_message = "The CloudTrail retention period must be supported by CloudWatch Logs."
  }
}

variable "cloudtrail_s3_expiration_days" {
  description = "Number of days CloudTrail logs are retained in S3."
  type        = number
  default     = 365

  validation {
    condition     = var.cloudtrail_s3_expiration_days >= 90
    error_message = "CloudTrail S3 logs must be retained for at least 90 days."
  }
}

variable "enable_key_rotation" {
  description = "Enables automatic annual rotation for the customer-managed KMS key."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags applied to security resources."
  type        = map(string)
  default     = {}
}