###############################################################################
# Amazon Linux 2023 AMI
###############################################################################

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

###############################################################################
# EC2 Application Server
###############################################################################

resource "aws_instance" "application" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.application_subnet_ids[0]
  vpc_security_group_ids = [var.application_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.compute.name
  user_data              = file("${path.module}/user-data.sh")

  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(local.tags, {
    Name = "${var.name_prefix}-app-server"
    Tier = "Application"
  })
}