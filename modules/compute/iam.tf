###############################################################################
# EC2 IAM Role
###############################################################################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "AllowEC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "compute" {
  name               = "${var.name_prefix}-compute-role"
  description        = "IAM role used by private EC2 application instances."
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-compute-role"
    Component = "Compute"
  })
}

###############################################################################
# Systems Manager Access
###############################################################################

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.compute.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

###############################################################################
# CloudWatch Agent Access
###############################################################################

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server" {
  role       = aws_iam_role.compute.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

###############################################################################
# EC2 Instance Profile
###############################################################################

resource "aws_iam_instance_profile" "compute" {
  name = "${var.name_prefix}-compute-instance-profile"
  role = aws_iam_role.compute.name

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-compute-instance-profile"
    Component = "Compute"
  })
}