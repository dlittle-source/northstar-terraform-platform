# NorthStar Terraform Platform

Production-style AWS Infrastructure as Code (IaC) platform built with Terraform.

This repository demonstrates how to design, deploy, validate, and manage a secure, modular AWS infrastructure platform using Terraform and AWS best practices.

The project is structured to simulate an enterprise cloud environment and is being built incrementally through multiple production-style phases. The completed phases establish a secure networking, identity, auditing, compute, application delivery, monitoring, observability, and CI/CD foundation.

---

# Project Objectives

- Build reusable Terraform modules
- Design enterprise AWS infrastructure using Infrastructure as Code (IaC)
- Follow AWS Well-Architected Framework best practices
- Implement modular, scalable, and maintainable Terraform code
- Deploy application compute resources into private subnets
- Apply least-privilege identity and network security controls
- Implement infrastructure monitoring, operational dashboards, and automated alerting
- Automate Terraform validation and deployment through GitHub Actions
- Use secure OIDC authentication without long-lived AWS credentials
- Maintain persistent Terraform state in Amazon S3
- Validate infrastructure through the AWS Management Console
- Demonstrate complete infrastructure lifecycle management
- Produce an interview-ready Cloud Platform Engineering portfolio

---

# Technologies

- Terraform
- Amazon Web Services (AWS)
- Amazon VPC
- Amazon EC2
- Amazon Elastic Block Store (EBS)
- Elastic Load Balancing
- Application Load Balancer (ALB)
- Target Groups
- AWS Identity and Access Management (IAM)
- AWS Systems Manager
- AWS Systems Manager Fleet Manager
- Amazon CloudWatch
- Amazon CloudWatch Dashboards
- Amazon CloudWatch Metrics
- Amazon CloudWatch Alarms
- Amazon Simple Notification Service (SNS)
- Amazon CloudWatch Agent
- AWS Key Management Service (KMS)
- AWS CloudTrail
- Amazon S3
- Security Groups
- VPC Flow Logs
- Internet Gateway
- NAT Gateway
- Route Tables
- Amazon Linux 2023
- Nginx
- Multi-Availability Zone (Multi-AZ) Networking
- GitHub Actions
- GitHub Actions OIDC
- Terraform S3 Remote State
- S3 Native State Locking
- PowerShell

---

# Project Progress

| Phase | Status |
|--------|--------|
| Phase 1 – Planning & Architecture | ✅ Complete |
| Phase 2 – Repository & Terraform Foundation | ✅ Complete |
| Phase 3 – Networking Foundation | ✅ Complete |
| Phase 4 – Security & IAM | ✅ Complete |
| Phase 5 – Compute Layer | ✅ Complete |
| Phase 6 – Application Delivery Layer | ✅ Complete |
| Phase 7 – Monitoring & Observability | ✅ Complete |
| Phase 8 – CI/CD Automation | ✅ Complete |

---

# Phase 3 – Networking Foundation

Phase 3 established the core networking architecture for the platform.

## Infrastructure Deployed

- Amazon VPC
- Public Subnets
- Private Application Subnets
- Private Database Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Route Table Associations
- Elastic IP
- VPC Flow Logs
- CloudWatch Log Group

## Networking Architecture

The networking module implements a multi-tier VPC architecture designed to separate internet-facing, application, and database resources.

Public subnets provide controlled internet connectivity through the Internet Gateway. Private application subnets use a NAT Gateway for outbound access, while database subnets remain isolated from direct internet traffic.

The networking infrastructure was successfully deployed, validated within the AWS Management Console, documented, and safely removed using Terraform.

---

# Phase 4 – Security & IAM

Phase 4 built upon the networking foundation by implementing enterprise security services that support encryption, auditing, identity, and network segmentation.

The objective of this phase was to create a production-style security architecture aligned with AWS security best practices and the AWS Well-Architected Framework.

## Security Components Deployed

- Customer Managed AWS KMS Key
- KMS Alias
- Multi-Region AWS CloudTrail
- CloudTrail Audit S3 Bucket
- CloudWatch Audit Log Group
- CloudTrail IAM Delivery Role
- Application Load Balancer Security Group
- Application Tier Security Group
- Database Tier Security Group

## Security Architecture

Phase 4 introduced:

- Customer-managed encryption
- Centralized audit logging
- Multi-region API activity tracking
- Least-privilege IAM design
- Layered network security
- Three-tier Security Group architecture
- CloudTrail log validation
- Long-term audit log retention

All resources were successfully deployed, validated, documented, and destroyed using Terraform.

---

# Phase 5 – Compute Layer

Phase 5 introduced a secure, production-style compute layer for application workloads.

The application server was deployed into a private application subnet without a public IP address. Administrative access is provided through AWS Systems Manager instead of inbound SSH, reducing the server's external attack surface.

The compute resources are managed through a dedicated reusable Terraform module that integrates with the networking and security modules established during earlier phases.

## Compute Components Deployed

- Amazon Linux 2023 EC2 Application Server
- Dedicated Compute Terraform Module
- EC2 IAM Role
- IAM Instance Profile
- Amazon SSM Managed Instance Core Policy
- CloudWatch Agent Server Policy
- Encrypted gp3 EBS Root Volume
- EC2 User Data Bootstrap Script
- AWS Systems Manager Managed Node
- Existing Application Tier Security Group

## Compute Architecture

The application server was configured with the following production-focused controls:

- Deployment into a private application subnet
- No public IPv4 address
- Application traffic restricted to TCP port 80 from the Application Load Balancer Security Group
- IAM role-based access without long-lived AWS credentials
- Systems Manager access without opening inbound SSH
- Encrypted 20 GiB gp3 root volume
- Instance Metadata Service Version 2 required
- Automatic first-boot configuration through EC2 user data
- Amazon CloudWatch Agent installation and permissions
- Standardized enterprise resource tagging

## Server Bootstrap Automation

The EC2 instance uses a user data script to automate its initial configuration.

The bootstrap process:

- Updates Amazon Linux packages
- Installs the Amazon CloudWatch Agent
- Installs administrative utilities
- Installs and configures Nginx
- Enables the CloudWatch Agent service
- Enables the Nginx service
- Creates the NorthStar application landing page
- Creates a local bootstrap validation log

This approach reduces manual configuration and makes the server deployment repeatable and auditable.

## Systems Manager Integration

The application server successfully registered as an online AWS Systems Manager managed node.

Systems Manager provides secure administrative access and operational management without requiring:

- A public IP address
- An inbound SSH rule
- An EC2 key pair
- Direct exposure to the internet

All compute resources were successfully deployed, validated in the AWS Management Console, documented, and safely removed using Terraform.

---

# Phase 6 – Application Delivery Layer

Phase 6 introduced the application delivery layer for the NorthStar platform.

The objective of this phase was to provide a controlled public entry point for application traffic while keeping the EC2 application server securely deployed within a private application subnet.

## Application Delivery Components Deployed

- Dedicated Application Delivery Terraform Module
- Internet-Facing Application Load Balancer
- Application Load Balancer deployed across Public Subnets
- Multi-Availability Zone Load Balancer deployment
- HTTP Listener on Port 80
- Listener Rule using `/*`
- Application Target Group
- HTTP Health Checks on `/`
- EC2 Target Registration
- Automatic Traffic Routing
- Existing Application Load Balancer Security Group
- Existing Application Tier Security Group
- Nginx Application Backend
- NorthStar Application Landing Page

## Application Delivery Architecture

The Application Load Balancer is deployed across public subnets and provides the internet-facing entry point for the NorthStar application.

Incoming HTTP traffic is accepted by the ALB listener on port 80 and forwarded through the application target group to the private EC2 application server.

The Application Security Group permits HTTP port 80 traffic from the Application Load Balancer Security Group while preventing direct internet access to the application server.

The application server remains deployed within a private application subnet with no public IPv4 address.

Nginx is installed and configured through EC2 user data and provides the backend HTTP service used by the Application Load Balancer.

The target group performs HTTP health checks against `/` and successfully reported the EC2 application target as Healthy.

The NorthStar application was successfully accessed through the Application Load Balancer DNS endpoint.

All Phase 6 resources were successfully deployed, validated, documented, and safely removed using Terraform.

---

# Phase 7 – Monitoring & Observability

Phase 7 introduced a centralized monitoring and observability layer for the NorthStar platform.

The objective of this phase was to provide operational visibility into the EC2 application server, Application Load Balancer, and application target health while implementing automated infrastructure alarms and an alert notification path.

The monitoring resources are managed through a dedicated reusable Terraform module that consumes outputs from the existing compute and application delivery modules without redesigning the working infrastructure established during Phases 1–6.

## Monitoring & Observability Components Deployed

- Dedicated Monitoring Terraform Module
- Amazon CloudWatch Dashboard
- EC2 CPU Utilization Monitoring
- EC2 Network Monitoring
- EC2 Status Check Monitoring
- Application Load Balancer Request Monitoring
- Application Load Balancer Target Response Time Monitoring
- Application Load Balancer Target 5XX Monitoring
- Target Group Healthy Host Monitoring
- Target Group Unhealthy Host Monitoring
- Five Amazon CloudWatch Alarms
- Amazon SNS Operations Alert Topic

## CloudWatch Dashboard

A centralized CloudWatch dashboard was created to provide visibility into the primary NorthStar infrastructure and application delivery metrics.

The dashboard includes monitoring for:

- EC2 CPU Utilization
- EC2 Network In
- EC2 Network Out
- Application Load Balancer Request Count
- Application Target 5XX Errors
- Application Target Response Time
- Target Group Healthy Host Count
- Target Group Unhealthy Host Count

The dashboard provides a single operational view of compute utilization, application traffic, response performance, and target health.

## CloudWatch Alarms

Five operational CloudWatch alarms were implemented:

- EC2 High CPU Utilization
- EC2 Status Check Failure
- ALB Unhealthy Target
- ALB Target 5XX Errors
- ALB High Target Response Time

During validation, all five NorthStar monitoring alarms successfully reported an `OK` state.

## SNS Operations Alerting

An Amazon SNS topic named `northstar-portal-dev-operations-alerts` was created as the notification destination for CloudWatch alarm actions.

The monitoring alarms are configured to publish alarm notifications to the SNS operations topic.

No personal email subscription is stored in the Terraform repository, keeping the monitoring module reusable and preventing personal notification endpoints from being hard-coded into the infrastructure configuration.

All Phase 7 resources were successfully deployed, validated in the AWS Management Console, documented, and safely removed using Terraform.

---

# Phase 8 – CI/CD Automation

Phase 8 introduced automated Terraform validation and deployment through GitHub Actions.

The objective of this phase was to move the NorthStar platform from a manually executed Terraform workflow to a repeatable CI/CD process using secure AWS authentication, persistent remote Terraform state, and automated infrastructure validation and deployment.

## CI/CD Components Implemented

- GitHub Actions Terraform CI Workflow
- GitHub Actions Terraform Deploy Workflow
- GitHub Actions OIDC Authentication to AWS
- Dedicated `NorthStarGitHubActionsRole`
- Terraform Format Validation
- Terraform Initialization
- Terraform Configuration Validation
- Automated Terraform Planning
- Automated Terraform Apply
- Amazon S3 Remote Terraform State
- S3 Native Terraform State Locking
- Dedicated `terraform.ci.tfvars`
- Partial S3 Backend Configuration
- PowerShell Partial Deployment Cleanup Script

## GitHub Actions CI Workflow

The NorthStar Terraform CI workflow validates infrastructure changes before deployment.

The workflow performs:

- Repository checkout
- Terraform installation
- Terraform formatting checks
- AWS authentication using GitHub Actions OIDC
- AWS identity verification
- Terraform initialization
- Terraform validation
- Terraform plan using `terraform.ci.tfvars`

The final CI workflow successfully returned:

```text
Plan: 61 to add, 0 to change, 0 to destroy.
```

## GitHub Actions Deploy Workflow

A separate manually triggered GitHub Actions deployment workflow performs the controlled infrastructure deployment.

The deployment workflow:

- Authenticates to AWS through OIDC
- Initializes the persistent S3 Terraform backend
- Validates the Terraform configuration
- Creates a Terraform execution plan
- Applies the Terraform plan

The final GitHub Actions deployment successfully created the complete NorthStar platform.

## GitHub Actions OIDC Authentication

GitHub Actions authenticates to AWS through OpenID Connect (OIDC) and assumes the dedicated `NorthStarGitHubActionsRole`.

This design avoids storing long-lived AWS access keys in the GitHub repository or GitHub Actions secrets.

## Terraform Remote State

Phase 8 standardized the development environment on persistent Amazon S3 remote state.

The Terraform state is stored at:

```text
platform/dev/terraform.tfstate
```

The repository contains a partial S3 backend declaration while GitHub Actions supplies the environment-specific backend configuration during `terraform init`.

S3 native state locking is enabled using:

```text
use_lockfile = true
```

After the successful GitHub Actions deployment, `terraform state list` returned the complete NorthStar resource inventory across the networking, security, compute, application delivery, and monitoring modules.

A final Terraform plan returned:

```text
No changes. Your infrastructure matches the configuration.
```

This confirmed that the deployed AWS infrastructure, Terraform configuration, and persistent remote state were synchronized with no detected drift.

## Deployment Recovery Automation

During Phase 8 testing, failed and partial deployments exposed AWS dependency-order challenges involving NAT Gateways, Application Load Balancers, EC2 instances, network interfaces, Security Groups, CloudTrail resources, versioned S3 objects, IAM resources, and KMS resources.

A PowerShell recovery script named `scripts/cleanup-partial-deployment.ps1` was developed and improved to safely remove orphaned partial deployments in dependency-aware order.

The recovery script was used only for failed deployments without usable Terraform state. Once persistent remote state was established, the final environment lifecycle was managed directly through Terraform.

All Phase 8 resources were successfully deployed through GitHub Actions, validated, documented, and safely removed using Terraform.

---

# Deployment Workflow

Deploy the infrastructure using the standard Terraform workflow.

```bash
terraform fmt -recursive
```

Formats all Terraform configuration files according to HashiCorp standards.

```bash
terraform init
```

Initializes the Terraform working directory, backend, providers, and referenced modules.

```bash
terraform validate
```

Checks the Terraform configuration for syntax errors and invalid references.

```bash
terraform plan
```

Creates a preview of the infrastructure changes Terraform intends to perform.

```bash
terraform apply
```

Creates or updates AWS infrastructure to match the desired Terraform configuration.

After deployment, validate the infrastructure using the AWS Management Console.

Destroy the development environment when validation is complete.

```bash
terraform destroy
```

Removes the AWS resources managed by the selected Terraform environment.

---

# Project Structure

```text
northstar-terraform-platform/
│
├── environments/
│   ├── dev/
│   └── prod/
│
├── modules/
│   ├── application-delivery/
│   ├── compute/
│   │   ├── compute.tf
│   │   ├── iam.tf
│   │   ├── locals.tf
│   │   ├── user-data.sh
│   │   └── variables.tf
│   │
│   ├── monitoring/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   │
│   ├── networking/
│   └── security/
│
├── diagrams/
├── screenshots/
├── scripts/
│   └── cleanup-partial-deployment.ps1
├── assets/
├── .github/
│   └── workflows/
│       ├── terraform.yml
│       └── terraform-deploy.yml
├── .gitignore
└── README.md
```

Each infrastructure domain is separated into a dedicated Terraform module to support maintainability, reuse, testing, and separation of responsibilities.

---

# Validation

Infrastructure was validated directly within the AWS Management Console after each deployment.

## Networking

- Amazon VPC
- Public Subnets
- Application Subnets
- Database Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Route Table Associations
- VPC Flow Logs
- CloudWatch Log Group

## Security

- Customer Managed AWS KMS Key
- AWS CloudTrail
- CloudTrail S3 Audit Bucket
- CloudWatch Audit Log Group
- CloudTrail IAM Role
- Three-Tier Security Groups

## Compute

- EC2 instance running successfully
- Amazon Linux 2023 operating system
- `t3.micro` instance type
- Private application subnet placement
- Private IPv4 address assigned
- No public IPv4 address assigned
- Application Security Group attached
- Compute IAM role attached
- IAM instance profile attached
- Encrypted 20 GiB EBS root volume
- AWS Systems Manager managed node online
- SSM Agent registration confirmed
- Nginx installed and running

## Application Delivery

- Internet-facing Application Load Balancer created successfully
- ALB deployed across public subnets
- ALB status confirmed Active
- HTTP listener configured on port 80
- Listener rule configured using `/*`
- Application target group created successfully
- EC2 application server registered with target group
- HTTP health check configured on `/`
- Target Group status confirmed Healthy
- Application Security Group restricted to HTTP/80 from the ALB Security Group
- Private EC2 application server confirmed without a public IPv4 address
- NorthStar application successfully accessed through the ALB DNS endpoint

## Monitoring & Observability

- CloudWatch dashboard created successfully
- EC2 CPU utilization metrics confirmed
- EC2 network metrics confirmed
- Application Load Balancer metrics confirmed
- ALB Request Count activity confirmed
- Target Group health monitoring configured
- Five NorthStar CloudWatch alarms created successfully
- All five NorthStar alarms confirmed in `OK` state during validation
- SNS operations alert topic created successfully
- CloudWatch alarms configured with SNS alarm actions

## CI/CD Automation

- GitHub Actions OIDC authentication to AWS confirmed
- Dedicated GitHub Actions IAM role confirmed
- Terraform CI workflow completed successfully
- CI plan confirmed 61 to add, 0 to change, 0 to destroy
- Terraform Deploy workflow completed successfully
- Persistent S3 remote state confirmed
- S3 native Terraform state locking configured
- Complete Terraform resource state verified after GitHub Actions deployment
- Live NorthStar application confirmed through the ALB
- Post-deployment Terraform plan confirmed zero drift
- Terraform-driven destroy completed successfully
- 61 resources destroyed

Every resource was verified after deployment before the environment was safely removed using Terraform.

---

# Phase 8 Validation Checklist

- GitHub Actions OIDC authentication completed successfully
- `NorthStarGitHubActionsRole` successfully assumed by GitHub Actions
- Terraform CI workflow completed successfully
- Terraform formatting check completed successfully
- Terraform initialization completed successfully
- Terraform validation completed successfully
- CI plan confirmed 61 to add, 0 to change, 0 to destroy
- Terraform Deploy workflow completed successfully
- 61 resources successfully created
- S3 remote state configured at `platform/dev/terraform.tfstate`
- S3 native Terraform state locking configured
- Terraform state successfully populated after GitHub Actions deployment
- NorthStar application successfully accessed through the ALB
- Post-deployment Terraform plan confirmed no infrastructure drift
- Five Phase 8 screenshots captured
- Terraform destroy completed successfully
- 61 resources destroyed

---

# Screenshots

Deployment screenshots are located in the **`screenshots/`** directory.

## Phase 3 – Networking Foundation

- 01 – VPC Overview
- 02 – Subnet Overview
- 03 – Route Table Association
- 04 – Internet Gateway
- 05 – NAT Gateway
- 06 – Route Tables
- 07 – VPC Flow Logs
- 08 – CloudWatch Log Group
- 09 – Networking Validation

## Phase 4 – Security & IAM

- 10 – Security Groups Overview
- 11 – Customer Managed KMS Key
- 12 – CloudTrail Overview
- 13 – CloudTrail S3 Audit Bucket
- 14 – CloudWatch CloudTrail Log Group

## Phase 5 – Compute Layer

- 15 – EC2 Instance Overview
- 16 – EC2 Networking and Private Subnet
- 17 – EC2 Security Group and IAM Role
- 18 – Encrypted EC2 EBS Storage
- 19 – Systems Manager Managed Node

## Phase 6 – Application Delivery Layer

- 20 – ALB Application Response
- 21 – Target Group Healthy
- 22 – Application Load Balancer Overview
- 23 – ALB Listener and Rule
- 24 – Private EC2 Application Server

## Phase 7 – Monitoring & Observability

- 25 – CloudWatch Dashboard
- 26 – CloudWatch Alarms
- 27 – ALB Monitoring Metrics
- 28 – EC2 Monitoring Metrics
- 29 – SNS Operations Alert Topic

## Phase 8 – CI/CD Automation

- 30 – GitHub Actions Terraform CI
- 31 – GitHub Actions Terraform Deploy
- 32 – GitHub Actions OIDC IAM Role
- 33 – S3 Terraform Remote State
- 34 – NorthStar Application CI/CD Deployment

All screenshots were captured after successful Terraform deployment and AWS Console validation.

---

# Operational Runbook

The following workflow can be used to deploy, validate, troubleshoot, and safely remove the NorthStar development environment.

## Deployment

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

After deployment:

- Confirm the EC2 application server is running
- Confirm the EC2 instance has no public IPv4 address
- Confirm the Application Load Balancer is Active
- Confirm the HTTP listener is configured on port 80
- Confirm the listener rule forwards traffic to the application target group
- Confirm the EC2 instance is registered with the target group
- Confirm the target status is Healthy
- Confirm Nginx is running on the application server
- Access the NorthStar application through the ALB DNS endpoint
- Confirm the NorthStar CloudWatch dashboard exists
- Confirm EC2 monitoring metrics are reporting
- Confirm Application Load Balancer monitoring metrics are reporting
- Confirm all five NorthStar CloudWatch alarms exist
- Confirm the SNS operations alert topic exists
- Confirm the GitHub Actions CI workflow completes successfully
- Confirm the GitHub Actions Deploy workflow completes successfully
- Confirm GitHub Actions authenticates to AWS using OIDC
- Confirm Terraform state is stored in the S3 remote backend
- Confirm `terraform state list` returns the deployed platform resources
- Confirm a post-deployment Terraform plan reports no changes

## Destruction

After validation and screenshot collection:

```bash
terraform destroy -var-file="terraform.ci.tfvars"
```

The final Phase 8 environment was successfully destroyed with:

```text
Destroy complete! Resources: 61 destroyed.
```

Before destruction, a post-deployment Terraform plan returned:

```text
No changes. Your infrastructure matches the configuration.
```

This confirmed that the complete environment deployed through GitHub Actions matched the Terraform configuration and was managed through the persistent S3 remote state.

---

# Troubleshooting Notes

## ALB and Target Group Naming Constraints

During Phase 6, AWS naming constraints affected the Application Load Balancer and Target Group resource names.

The resource names were adjusted to comply with AWS naming requirements while maintaining the NorthStar naming convention.

## Port 8080 to Port 80 Alignment

The earlier compute configuration referenced TCP port 8080 for application traffic.

During Phase 6, the application delivery path was aligned on HTTP/TCP port 80.

The ALB listener, Target Group, Application Security Group, EC2 application server, and Nginx backend were configured to use port 80.

## Nginx Backend Requirement

The Application Load Balancer required a functioning HTTP backend on the registered EC2 target.

Nginx was installed and configured through EC2 user data to provide the backend web service and NorthStar application landing page.

## Unhealthy Target Troubleshooting

Target health required validation across multiple components:

- EC2 instance state
- Target registration
- Target Group port
- HTTP health check path
- Application Security Group rules
- ALB Security Group rules
- Nginx service status
- Backend listening port

After the application delivery configuration was aligned, the EC2 target successfully reported a Healthy status.

## CloudWatch Metric Availability

CloudWatch metrics may require several minutes after infrastructure deployment before data points appear on a newly created dashboard.

During Phase 7 validation, EC2 and Application Load Balancer activity was confirmed in CloudWatch while the monitoring configuration and alarms were successfully deployed.

## CI/CD Remote State and Deployment Recovery

During Phase 8, early GitHub Actions deployments exposed a backend configuration issue in which the workflow runner did not initially have a tracked S3 backend declaration.

The CI/CD configuration was corrected by adding a partial S3 backend declaration to the repository and supplying the environment-specific S3 backend settings during GitHub Actions `terraform init`.

The Terraform state path was standardized as:

```text
platform/dev/terraform.tfstate
```

The GitHub Actions IAM policy was updated to grant access to the matching Terraform state and `.tflock` objects.

A dependency-aware PowerShell cleanup script was developed to recover partial deployments that did not have usable Terraform state.

The final deployment successfully persisted its Terraform state to S3, returned the complete resource inventory through `terraform state list`, and produced a zero-drift Terraform plan.

---

# Architecture Principles

The platform follows enterprise cloud engineering principles.

- Modular Terraform architecture
- Infrastructure as Code (IaC)
- Separation of concerns
- Least-privilege security
- Defense in depth
- Private application compute
- Controlled application delivery
- Centralized infrastructure monitoring
- Operational metrics and dashboards
- Automated infrastructure alerting
- Multi-Availability Zone network design
- Multi-Availability Zone load balancing
- Reusable Terraform modules
- Standardized resource naming
- Standardized enterprise tagging
- Encryption at rest
- Secure administrative access
- Infrastructure automation
- Secure-by-default configuration
- Production lifecycle management
- CI/CD infrastructure automation
- Short-lived OIDC authentication
- Persistent remote Terraform state
- Terraform state locking
- Automated infrastructure validation and deployment

---

# AWS Well-Architected Alignment

## Security

- Customer-managed KMS encryption
- Centralized CloudTrail auditing
- Private application server placement
- Layered Security Group controls
- ALB-to-application Security Group restriction
- IMDSv2 enforcement
- IAM roles instead of embedded credentials
- Systems Manager instead of public SSH access
- Encrypted EBS storage
- GitHub Actions OIDC authentication without long-lived AWS access keys

## Operational Excellence

- Reusable Terraform modules
- Dedicated monitoring and observability module
- Centralized CloudWatch operational dashboard
- Automated CloudWatch alarms
- SNS-based operations alerting
- Automated server bootstrap
- Nginx application configuration through user data
- Standard Terraform validation workflow
- AWS Console deployment verification
- Version-controlled infrastructure
- Documented deployment evidence
- GitHub Actions CI/CD automation
- OIDC-based AWS authentication
- Persistent S3 Terraform state
- Terraform state locking
- Automated Terraform plan and deployment workflows

## Reliability

- Multi-Availability Zone network design
- Multi-Availability Zone Application Load Balancer
- Target Group health checks
- EC2 status check monitoring
- Unhealthy target monitoring
- Application response-time monitoring
- Application 5XX error monitoring
- Repeatable infrastructure deployments
- Terraform-managed dependencies
- Application, public, and database tier separation
- Persistent remote state for infrastructure lifecycle management

## Cost Optimization

- Development-sized EC2 instance
- gp3 EBS storage
- Deploy, validate, and destroy workflow
- Removal of unused development resources

---

# Lessons Learned

This project demonstrates practical experience with:

- Infrastructure as Code using Terraform
- Modular Terraform architecture
- Terraform root modules and child modules
- AWS networking
- Private EC2 compute architecture
- Amazon Linux 2023
- IAM roles and instance profiles
- AWS Systems Manager
- EC2 user data automation
- Nginx application configuration
- CloudWatch Agent integration
- Encrypted EBS storage
- IMDSv2 security enforcement
- Enterprise security architecture
- Customer-managed encryption
- AWS CloudTrail auditing
- CloudWatch centralized logging
- CloudWatch infrastructure metrics
- CloudWatch dashboards
- CloudWatch alarms
- Amazon SNS operational alerting
- EC2 performance monitoring
- Application Load Balancer monitoring
- Target Group health monitoring
- Security Group segmentation
- Multi-AZ networking
- Application Load Balancer deployment
- Target Groups and health checks
- Listener rules and automatic traffic routing
- Private application delivery
- Infrastructure troubleshooting
- Infrastructure validation
- Production deployment workflows
- Safe infrastructure lifecycle management
- Git-based infrastructure change tracking
- GitHub Actions CI/CD
- GitHub Actions OIDC authentication
- AWS IAM federation for CI/CD
- Terraform partial backend configuration
- Amazon S3 remote Terraform state
- Terraform state locking
- CI/CD IAM troubleshooting
- Dependency-aware failed deployment recovery
- Automated Terraform validation, planning, and deployment

---

# Future Enhancements

Future enhancements may include:

- Centralized Application Logging
- Auto Scaling Groups
- Disaster Recovery Enhancements
- Cost Optimization Controls
- Enhanced NorthStar Application Experience

---

# Author

**Demarko Little**

Cloud Platform Engineer | DevOps Engineer
