data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    sid    = "AllowCloudTrailAssumeRole"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "cloudtrail_cloudwatch" {
  name               = "${local.name_prefix}-cloudtrail-cloudwatch-role"
  description        = "Allows CloudTrail to deliver AWS API activity to CloudWatch Logs."
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json

  tags = merge(
    local.security_tags,
    {
      Name    = "${local.name_prefix}-cloudtrail-cloudwatch-role"
      Purpose = "CloudTrail log delivery"
    }
  )
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch" {
  statement {
    sid    = "AllowCloudTrailLogStreamCreation"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:*"
    ]
  }

  statement {
    sid    = "AllowCloudTrailLogDelivery"
    effect = "Allow"

    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:*"
    ]
  }
}

resource "aws_iam_role_policy" "cloudtrail_cloudwatch" {
  name   = "${local.name_prefix}-cloudtrail-cloudwatch-policy"
  role   = aws_iam_role.cloudtrail_cloudwatch.id
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch.json
}