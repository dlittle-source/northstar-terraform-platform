# NorthStar Terraform Platform

Production-style AWS Infrastructure as Code (IaC) platform built with Terraform.

This repository demonstrates how to design, deploy, validate, and manage a secure, modular AWS infrastructure platform using Terraform and AWS best practices.

The project is structured to simulate an enterprise cloud environment and is being built incrementally through multiple production-style phases. The completed phases establish a secure networking, identity, auditing, and compute foundation upon which monitoring, automation, and additional application services can be built.

---

# Project Objectives

- Build reusable Terraform modules
- Design enterprise AWS infrastructure using Infrastructure as Code (IaC)
- Follow AWS Well-Architected Framework best practices
- Implement modular, scalable, and maintainable Terraform code
- Deploy application compute resources into private subnets
- Apply least-privilege identity and network security controls
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
- AWS Identity and Access Management (IAM)
- AWS Systems Manager
- AWS Systems Manager Fleet Manager
- Amazon CloudWatch
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
- Multi-Availability Zone (Multi-AZ) Networking

---

# Project Progress

| Phase | Status |
|--------|--------|
| Phase 1 – Planning & Architecture | ✅ Complete |
| Phase 2 – Repository & Terraform Foundation | ✅ Complete |
| Phase 3 – Networking Foundation | ✅ Complete |
| Phase 4 – Security & IAM | ✅ Complete |
| Phase 5 – Compute Layer | ✅ Complete |
| Phase 6 – Monitoring & Observability | ⏳ Planned |
| Phase 7 – CI/CD Automation | ⏳ Planned |

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
- Application traffic restricted to TCP port 8080 from the Application Load Balancer Security Group
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
- Enables the CloudWatch Agent service
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

├── environments/
│   ├── dev/
│   └── prod/
│
├── modules/
│   ├── compute/
│   │   ├── compute.tf
│   │   ├── iam.tf
│   │   ├── locals.tf
│   │   ├── user-data.sh
│   │   └── variables.tf
│   │
│   ├── networking/
│   └── security/
│
├── diagrams/
├── screenshots/
├── assets/
├── .github/
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

Every resource was verified after deployment before the environment was safely removed using Terraform.

---

# Screenshots

Deployment screenshots are located in the **screenshots/** directory.

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

All screenshots were captured after successful Terraform deployment and AWS Console validation.

---

# Architecture Principles

The platform follows enterprise cloud engineering principles.

- Modular Terraform architecture
- Infrastructure as Code (IaC)
- Separation of concerns
- Least-privilege security
- Defense in depth
- Private application compute
- Multi-Availability Zone network design
- Reusable Terraform modules
- Standardized resource naming
- Standardized enterprise tagging
- Encryption at rest
- Secure administrative access
- Infrastructure automation
- Secure-by-default configuration
- Production lifecycle management

---

# AWS Well-Architected Alignment

## Security

- Customer-managed KMS encryption
- Centralized CloudTrail auditing
- Private application server placement
- Layered Security Group controls
- IMDSv2 enforcement
- IAM roles instead of embedded credentials
- Systems Manager instead of public SSH access
- Encrypted EBS storage

## Operational Excellence

- Reusable Terraform modules
- Automated server bootstrap
- Standard Terraform validation workflow
- AWS Console deployment verification
- Version-controlled infrastructure
- Documented deployment evidence

## Reliability

- Multi-Availability Zone network design
- Repeatable infrastructure deployments
- Terraform-managed dependencies
- Application, public, and database tier separation

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
- CloudWatch Agent integration
- Encrypted EBS storage
- IMDSv2 security enforcement
- Enterprise security architecture
- Customer-managed encryption
- AWS CloudTrail auditing
- CloudWatch centralized logging
- Security Group segmentation
- Multi-AZ networking
- Infrastructure validation
- Production deployment workflows
- Safe infrastructure lifecycle management
- Git-based infrastructure change tracking

---

# Hiring Manager Talking Points

This project demonstrates the ability to:

- Design modular AWS infrastructure using Terraform
- Deploy application workloads into private subnets
- Integrate Terraform modules through clearly defined inputs and outputs
- Secure EC2 instances without relying on public IP addresses or inbound SSH
- Implement IAM roles and instance profiles for AWS service access
- Enforce encryption and modern EC2 metadata security
- Automate Linux server initialization through user data
- Validate deployed infrastructure through Terraform and the AWS Management Console
- Document architecture decisions and operational evidence
- Reproduce and safely destroy complete AWS environments

---

# Future Enhancements

Future phases will extend the platform with:

- CloudWatch Metrics and Alarms
- Centralized Application Logging
- SNS Notifications
- Monitoring Dashboards
- Application Load Balancer
- Target Groups and Health Checks
- Auto Scaling Groups
- GitHub Actions CI/CD Pipeline
- Terraform Automation
- Disaster Recovery Enhancements
- Cost Optimization Controls

---

# Author

**Demarko Little**

Cloud Platform Engineer | DevOps Engineer