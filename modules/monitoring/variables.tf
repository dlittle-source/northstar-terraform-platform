variable "name_prefix" {
  description = "Naming prefix used for monitoring resources"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the application target group"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to monitoring resources"
  type        = map(string)
}