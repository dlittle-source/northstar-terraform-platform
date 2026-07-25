# Networking Module

Creates the Northstar environment network:

- One VPC with DNS support and hostnames
- Public subnets across at least two Availability Zones
- Private application subnets across at least two Availability Zones
- Isolated database subnets across at least two Availability Zones
- Internet Gateway
- Configurable single or per-AZ NAT Gateway design
- Public, application, and database route tables
- Optional VPC Flow Logs to CloudWatch Logs
- Required IAM role and policy for Flow Logs

Database subnets intentionally have no default route to the Internet.

## NAT Gateway modes

- `single`: one NAT Gateway in the first Availability Zone. Appropriate for cost-conscious development.
- `one_per_az`: one NAT Gateway per Availability Zone. Appropriate for production resilience and avoiding cross-AZ egress dependencies.
