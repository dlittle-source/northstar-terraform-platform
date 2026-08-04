# NorthStar Terraform Platform

Production-style AWS Infrastructure as Code (IaC) platform built with Terraform.

This repository demonstrates how to design, deploy, validate, and manage a secure, modular AWS infrastructure platform using Terraform and AWS best practices.

The project is structured to simulate an enterprise cloud environment and is being built incrementally through multiple production-style phases. The completed phases establish the networking and security foundation that future compute, monitoring, and CI/CD capabilities will build upon.

---

# Project Objectives

- Build reusable Terraform modules
- Design enterprise AWS infrastructure using Infrastructure as Code (IaC)
- Follow AWS Well-Architected Framework best practices
- Implement modular, scalable, and maintainable Terraform code
- Validate infrastructure through the AWS Management Console
- Demonstrate complete infrastructure lifecycle management
- Produce an interview-ready Cloud Platform Engineering portfolio

---

# Technologies

- Terraform
- Amazon Web Services (AWS)
- Amazon VPC
- Amazon IAM
- AWS Key Management Service (KMS)
- AWS CloudTrail
- Amazon CloudWatch
- Amazon S3
- Security Groups
- VPC Flow Logs
- Internet Gateway
- NAT Gateway
- Route Tables
- Multi-Availability Zone (Multi-AZ) Networking

---

# Project Progress

| Phase | Status |
|--------|--------|
| Phase 1 – Planning & Architecture | ✅ Complete |
| Phase 2 – Repository & Terraform Foundation | ✅ Complete |
| Phase 3 – Networking Foundation | ✅ Complete |
| Phase 4 – Security & IAM | ✅ Complete |
| Phase 5 – Compute Layer | ⏳ Planned |
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

The networking infrastructure was successfully deployed, validated within the AWS Management Console, documented, and safely removed using Terraform.

---

# Phase 4 – Security & IAM

Phase 4 builds upon the networking foundation by implementing enterprise security services that support encryption, auditing, identity, and network segmentation.

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

Phase 4 introduces:

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

# Deployment Workflow

Deploy the infrastructure using the standard Terraform workflow.

```bash
terraform fmt -recursive

terraform init

terraform validate

terraform plan

terraform apply
```

After deployment, validate the infrastructure using the AWS Management Console.

Destroy the environment when validation is complete.

```bash
terraform destroy
```

---

# Project Structure

```text
northstar-terraform-platform/

├── environments/
│   ├── dev/
│   └── prod/
│
├── modules/
│   ├── networking/
│   └── security/
│
├── diagrams/
├── screenshots/
├── assets/
└── .github/
```

---

# Validation

Infrastructure was validated directly within the AWS Management Console.

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

All screenshots were captured after successful deployment and AWS Console validation.

---

# Architecture Principles

The platform follows enterprise cloud engineering principles.

- Modular Terraform architecture
- Infrastructure as Code (IaC)
- Least-Privilege Security
- Defense in Depth
- Multi-Availability Zone Design
- Reusable Terraform Modules
- Standardized Resource Tagging
- Secure-by-Default Configuration
- Production Lifecycle Management

---

# Lessons Learned

This project demonstrates practical experience with:

- Infrastructure as Code (Terraform)
- Modular Terraform architecture
- AWS networking
- Enterprise security architecture
- Customer-managed encryption
- AWS CloudTrail auditing
- CloudWatch centralized logging
- Security Group segmentation
- Multi-AZ networking
- Infrastructure validation
- Production deployment workflows
- Safe infrastructure lifecycle management

---

# Future Enhancements

Future phases will extend the platform with:

- EC2 Compute Layer
- Application Load Balancer
- Auto Scaling Groups
- IAM Instance Profiles
- Systems Manager (SSM)
- CloudWatch Alarms
- SNS Notifications
- GitHub Actions CI/CD Pipeline
- Disaster Recovery Enhancements
- Cost Optimization

---

# Author

**Demarko Little**

Cloud Platform Engineer | DevOps Engineer