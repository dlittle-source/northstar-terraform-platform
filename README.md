# Northstar Terraform Platform

Production-style AWS Infrastructure as Code (IaC) project built with Terraform.

This repository demonstrates how to design, deploy, validate, and manage a secure, modular AWS networking foundation using Terraform and AWS best practices. The project is structured to simulate an enterprise cloud environment and serves as the foundation for future infrastructure phases, including Security & IAM, Compute, Monitoring, and CI/CD Automation.

---

## Project Objectives

- Build reusable Terraform modules
- Deploy a production-style AWS networking foundation
- Follow Infrastructure as Code (IaC) best practices
- Implement modular, scalable, and maintainable infrastructure
- Validate infrastructure through the AWS Management Console
- Demonstrate complete infrastructure lifecycle management using Terraform
- Provide an interview-ready portfolio project based on real AWS deployments

---

## Technologies

- Terraform
- Amazon Web Services (AWS)
- Amazon VPC
- Amazon CloudWatch
- VPC Flow Logs
- Internet Gateway
- NAT Gateway
- Route Tables
- Multi-AZ Networking

---

## Project Progress

| Phase | Status |
|--------|--------|
| Phase 1 – Planning & Architecture | ✅ Complete |
| Phase 2 – Repository & Terraform Foundation | ✅ Complete |
| Phase 3 – Networking Foundation | ✅ Complete |
| Phase 4 – Security & IAM | 🚧 In Progress |
| Phase 5 – Compute Layer | ⏳ Planned |
| Phase 6 – Monitoring & Logging | ⏳ Planned |
| Phase 7 – CI/CD Automation | ⏳ Planned |

---

## Phase 3 – Networking Foundation

The networking foundation was successfully deployed using Terraform and validated within the AWS Management Console.

### Infrastructure Deployed

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

Following deployment, every resource was verified in AWS before the environment was successfully removed using Terraform.

---

## Deployment Workflow

Deploy the infrastructure using the standard Terraform workflow:

```bash
terraform fmt -recursive

terraform init

terraform validate

terraform plan

terraform apply
```

After deployment, validate the infrastructure using the AWS Management Console.

Destroy the environment when finished:

```bash
terraform destroy
```

---

## Project Structure

```text
northstar-terraform-platform/

├── environments/
│   ├── dev/
│   └── prod/
│
├── modules/
│   └── networking/
│
├── diagrams/
├── screenshots/
├── assets/
└── .github/
```

---

## Validation

The deployed infrastructure was validated by confirming the successful creation and configuration of:

- Amazon VPC
- Public Subnets
- Private Application Subnets
- Private Database Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Route Table Associations
- VPC Flow Logs
- CloudWatch Log Group

Validation was performed directly within the AWS Management Console after the Terraform deployment completed successfully.

---

## Screenshots

Deployment screenshots are available in the **screenshots/** directory and provide visual verification of the infrastructure created during Phase 3.

Captured resources include:

- Amazon VPC Overview
- Public Subnets
- Private Application Subnets
- Private Database Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Route Table Associations
- VPC Flow Logs
- CloudWatch Log Group

These screenshots document the successful deployment and validation of the networking foundation before the infrastructure was cleanly removed using `terraform destroy`.

---

## Lessons Learned

This phase demonstrates practical experience with:

- Infrastructure as Code (IaC)
- Modular Terraform architecture
- AWS networking fundamentals
- Multi-Availability Zone design
- Infrastructure validation
- Cloud resource lifecycle management
- Safe infrastructure teardown
- Production deployment workflows

---

## Future Enhancements

The following capabilities will be added during future phases:

- IAM Roles and Policies
- Security Groups
- Network ACLs
- AWS KMS Encryption
- EC2 Compute Layer
- Application Load Balancer (ALB)
- Auto Scaling Groups
- GitHub Actions CI/CD Pipeline
- CloudWatch Monitoring and Alerts
- CloudTrail Logging
- Cost Optimization

---

## Author

**Demarko Little**

Cloud Platform Engineer | DevOps Engineer