output "kms_key_id" {
  description = "ID of the platform customer-managed KMS key."
  value       = aws_kms_key.platform.key_id
}

output "kms_key_arn" {
  description = "ARN of the platform customer-managed KMS key."
  value       = aws_kms_key.platform.arn
}

output "kms_alias_name" {
  description = "Alias assigned to the platform KMS key."
  value       = aws_kms_alias.platform.name
}

output "cloudtrail_log_group_name" {
  description = "Name of the CloudWatch Log Group receiving CloudTrail events."
  value       = aws_cloudwatch_log_group.cloudtrail.name
}

output "cloudtrail_log_group_arn" {
  description = "ARN of the CloudWatch Log Group receiving CloudTrail events."
  value       = aws_cloudwatch_log_group.cloudtrail.arn
}

output "cloudtrail_cloudwatch_role_arn" {
  description = "ARN of the IAM role used by CloudTrail for CloudWatch Logs delivery."
  value       = aws_iam_role.cloudtrail_cloudwatch.arn
}

output "cloudtrail_bucket_id" {
  description = "Name of the S3 bucket storing CloudTrail audit logs."
  value       = aws_s3_bucket.cloudtrail.id
}

output "cloudtrail_bucket_arn" {
  description = "ARN of the S3 bucket storing CloudTrail audit logs."
  value       = aws_s3_bucket.cloudtrail.arn
}

output "cloudtrail_name" {
  description = "Name of the multi-region CloudTrail trail."
  value       = aws_cloudtrail.platform.name
}

output "cloudtrail_arn" {
  description = "ARN of the multi-region CloudTrail trail."
  value       = aws_cloudtrail.platform.arn
}

output "cloudtrail_home_region" {
  description = "Home AWS Region of the CloudTrail trail."
  value       = aws_cloudtrail.platform.home_region
}

output "alb_security_group_id" {
  description = "Security Group ID for the public Application Load Balancer."
  value       = aws_security_group.alb.id
}

output "application_security_group_id" {
  description = "Security Group ID for the application tier."
  value       = aws_security_group.application.id
}

output "database_security_group_id" {
  description = "Security Group ID for the database tier."
  value       = aws_security_group.database.id
}