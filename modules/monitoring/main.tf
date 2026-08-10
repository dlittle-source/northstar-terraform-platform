locals {
  alb_arn_suffix = element(split("loadbalancer/", var.alb_arn), 1)

  target_group_arn_suffix = element(
    split("targetgroup/", var.target_group_arn),
    1
  )
}

resource "aws_sns_topic" "operations_alerts" {
  name = "${var.name_prefix}-operations-alerts"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-operations-alerts"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "${var.name_prefix}-ec2-high-cpu"
  alarm_description   = "Triggers when EC2 CPU utilization exceeds 80 percent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [
    aws_sns_topic.operations_alerts.arn
  ]

  tags = var.common_tags
}

resource "aws_cloudwatch_metric_alarm" "ec2_status_check_failed" {
  alarm_name          = "${var.name_prefix}-ec2-status-check-failed"
  alarm_description   = "Triggers when the EC2 instance fails a status check"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [
    aws_sns_topic.operations_alerts.arn
  ]

  tags = var.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_target" {
  alarm_name          = "${var.name_prefix}-alb-unhealthy-target"
  alarm_description   = "Triggers when the ALB detects an unhealthy application target"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = local.alb_arn_suffix
    TargetGroup  = local.target_group_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.operations_alerts.arn
  ]

  tags = var.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name          = "${var.name_prefix}-alb-target-5xx"
  alarm_description   = "Triggers when application targets return HTTP 5XX errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = local.alb_arn_suffix
    TargetGroup  = local.target_group_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.operations_alerts.arn
  ]

  tags = var.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alb_response_time" {
  alarm_name          = "${var.name_prefix}-alb-high-response-time"
  alarm_description   = "Triggers when application target response time exceeds 2 seconds"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 2
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = local.alb_arn_suffix
    TargetGroup  = local.target_group_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.operations_alerts.arn
  ]

  tags = var.common_tags
}

resource "aws_cloudwatch_dashboard" "northstar" {
  dashboard_name = "${var.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "EC2 Application Server"
          region = "us-east-1"
          period = 300

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              var.instance_id
            ],
            [
              ".",
              "NetworkIn",
              ".",
              "."
            ],
            [
              ".",
              "NetworkOut",
              ".",
              "."
            ]
          ]

          stat = "Average"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "Application Load Balancer"
          region = "us-east-1"
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              local.alb_arn_suffix
            ],
            [
              ".",
              "HTTPCode_Target_5XX_Count",
              ".",
              "."
            ],
            [
              ".",
              "TargetResponseTime",
              ".",
              "."
            ]
          ]

          stat = "Average"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 24
        height = 6

        properties = {
          title  = "Target Group Health"
          region = "us-east-1"
          period = 60

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "TargetGroup",
              local.target_group_arn_suffix,
              "LoadBalancer",
              local.alb_arn_suffix
            ],
            [
              ".",
              "UnHealthyHostCount",
              ".",
              ".",
              ".",
              "."
            ]
          ]

          stat = "Average"
        }
      }
    ]
  })
}