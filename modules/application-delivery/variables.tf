variable "project_name" {
  description = "Name of the project used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the Application Load Balancer will operate"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs used by the Application Load Balancer"
  type        = list(string)
}

variable "ec2_instance_id" {
  description = "ID of the EC2 application server registered with the target group"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID assigned to the Application Load Balancer"
  type        = string
}

variable "name_prefix" {
  description = "Standardized prefix used for Application Delivery resource names"
  type        = string
}