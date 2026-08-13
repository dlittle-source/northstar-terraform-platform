#!/bin/bash
set -euxo pipefail

###############################################################################
# NorthStar EC2 Application Server Bootstrap
###############################################################################

# Update operating system packages
dnf update -y

# Install required packages
dnf install -y \
  amazon-cloudwatch-agent \
  nginx \
  htop \
  git \
  unzip

###############################################################################
# CloudWatch Agent
###############################################################################

systemctl enable amazon-cloudwatch-agent

###############################################################################
# Nginx Application Service
###############################################################################

systemctl enable nginx
systemctl start nginx

###############################################################################
# NorthStar Application Deployment
###############################################################################

echo '${northstar_html}' | base64 -d | gunzip > /usr/share/nginx/html/index.html

chmod 644 /usr/share/nginx/html/index.html

###############################################################################
# Validate and Reload Nginx
###############################################################################

nginx -t
systemctl reload nginx

###############################################################################
# Bootstrap Logging
###############################################################################

echo "NorthStar Compute Layer initialized successfully on $(date)" > /var/log/northstar-bootstrap.log
echo "NorthStar Operations application deployed successfully" >> /var/log/northstar-bootstrap.log
echo "Nginx application service started successfully" >> /var/log/northstar-bootstrap.log