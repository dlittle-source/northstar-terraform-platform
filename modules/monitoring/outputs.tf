output "dashboard_name" {
  description = "Name of the CloudWatch monitoring dashboard"
  value       = aws_cloudwatch_dashboard.northstar.dashboard_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS operations alerts topic"
  value       = aws_sns_topic.operations_alerts.arn
}

output "alarm_names" {
  description = "Names of the CloudWatch alarms"
  value = [
    aws_cloudwatch_metric_alarm.ec2_high_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.ec2_status_check_failed.alarm_name,
    aws_cloudwatch_metric_alarm.alb_unhealthy_target.alarm_name,
    aws_cloudwatch_metric_alarm.alb_target_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.alb_response_time.alarm_name
  ]
}