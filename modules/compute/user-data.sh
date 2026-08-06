#!/bin/bash
set -euxo pipefail

# Update operating system packages
dnf update -y

# Install useful utilities
dnf install -y \
    amazon-cloudwatch-agent \
    htop \
    git \
    unzip

# Enable CloudWatch Agent
systemctl enable amazon-cloudwatch-agent

# Create a bootstrap log
echo "NorthStar Compute Layer initialized successfully on $(date)" > /var/log/northstar-bootstrap.log