data "aws_iam_policy_document" "flow_logs_assume_role" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  name               = "${var.name_prefix}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role[0].json

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-vpc-flow-logs-role"
    Component = "Flow-Logs"
  })
}

data "aws_iam_policy_document" "flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  statement {
    sid    = "PublishFlowLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.flow_logs[0].arn}:*"
    ]
  }

  statement {
    sid    = "DescribeCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  name   = "${var.name_prefix}-vpc-flow-logs-policy"
  role   = aws_iam_role.flow_logs[0].id
  policy = data.aws_iam_policy_document.flow_logs[0].json
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  name              = "/aws/vpc/${var.name_prefix}/flow-logs"
  retention_in_days = var.flow_log_retention_days

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-vpc-flow-logs"
    Component = "Flow-Logs"
    DataClass = "Internal"
  })
}

resource "aws_flow_log" "this" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  iam_role_arn             = aws_iam_role.flow_logs[0].arn
  log_destination          = aws_cloudwatch_log_group.flow_logs[0].arn
  log_destination_type     = "cloud-watch-logs"
  traffic_type             = var.flow_log_traffic_type
  vpc_id                   = aws_vpc.this.id
  max_aggregation_interval = 60

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-vpc-flow-log"
    Component = "Flow-Logs"
  })
}