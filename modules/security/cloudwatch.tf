resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${local.name_prefix}"
  retention_in_days = var.cloudtrail_log_retention_days
  kms_key_id        = aws_kms_key.platform.arn

  tags = merge(
    local.security_tags,
    {
      Name    = "${local.name_prefix}-cloudtrail-logs"
      Purpose = "CloudTrail audit logging"
    }
  )
}