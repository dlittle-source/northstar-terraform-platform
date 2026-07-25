# Phase 3 Deployment Guide

## Prerequisites

- Terraform 1.10 or later
- AWS CLI configured with an authorized identity
- Phase 2 S3 state bucket created
- Permissions for VPC, EC2 networking, IAM, CloudWatch Logs, and VPC Flow Logs
- Awareness that NAT Gateways and VPC Flow Logs create AWS charges

## Prepare development

1. Copy `environments/dev/backend.tf.example` to `backend.tf`.
2. Replace the state bucket placeholder.
3. Copy `environments/dev/terraform.tfvars.example` to `terraform.tfvars`.
4. Confirm the two Availability Zones exist in the selected AWS account and Region.
5. Run:
   - `terraform -chdir=environments/dev fmt -recursive`
   - `terraform -chdir=environments/dev init`
   - `terraform -chdir=environments/dev validate`
   - `terraform -chdir=environments/dev plan -out=tfplan`
6. Review every create, change, and destroy action.
7. Run `terraform -chdir=environments/dev apply tfplan`.

## Expected development resources

- 1 VPC
- 1 Internet Gateway
- 6 subnets
- 1 Elastic IP
- 1 NAT Gateway
- 5 route tables
- Default routes for public and application tiers
- No Internet default route for database subnets
- 6 route-table associations
- 1 CloudWatch Log Group
- 1 IAM role and inline policy for VPC Flow Logs
- 1 VPC Flow Log

## Verification

- Confirm VPC DNS support and hostnames are enabled.
- Confirm subnets are distributed across two Availability Zones.
- Confirm application subnets route through the NAT Gateway.
- Confirm database subnet route tables have no `0.0.0.0/0` route.
- Confirm public subnets do not automatically assign public IP addresses.
- Confirm the VPC Flow Log reports an active status.
- Confirm the CloudWatch Log Group exists with the expected retention.
- Record Terraform outputs.

## Screenshot checklist

Capture:
1. VPC details
2. Six-subnet list with Availability Zones and CIDRs
3. Public route table
4. Application route tables and NAT routes
5. Database route tables showing no Internet route
6. NAT Gateway available status
7. VPC Flow Log active status
8. CloudWatch Flow Log group
9. Successful Terraform apply output
10. Terraform outputs

Do not expose account numbers, credentials, secret values, or personally identifying information in public screenshots.
