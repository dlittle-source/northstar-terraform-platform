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
# NorthStar Application Landing Page
###############################################################################

cat <<'EOF' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>NorthStar Terraform Platform</title>
</head>
<body>
  <h1>NorthStar Terraform Platform</h1>
  <h2>Application Delivery Layer</h2>
  <p>NorthStar application server is healthy and receiving traffic through the Application Load Balancer.</p>
</body>
</html>
EOF

###############################################################################
# Bootstrap Logging
###############################################################################

echo "NorthStar Compute Layer initialized successfully on $(date)" > /var/log/northstar-bootstrap.log
echo "Nginx application service started successfully" >> /var/log/northstar-bootstrap.log