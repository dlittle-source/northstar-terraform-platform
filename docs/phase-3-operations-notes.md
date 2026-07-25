# Phase 3 Operations Notes

## Failure behavior

Development uses one NAT Gateway. If its Availability Zone or NAT Gateway fails, outbound Internet connectivity from both application subnets is affected. This is an accepted development cost trade-off.

Production uses one NAT Gateway per Availability Zone. Each application subnet uses the NAT Gateway in its own Availability Zone.

## Database isolation

Database subnets have local VPC routing only. They receive no Internet default route. Database patching and service management are handled through the managed AWS service rather than direct Internet access.

## Troubleshooting order

1. Confirm subnet route-table association.
2. Confirm route target status.
3. Confirm NAT Gateway status and Elastic IP.
4. Confirm Network ACL defaults were not manually changed.
5. Review VPC Flow Logs for accepted or rejected traffic.
6. Review IAM permissions if Flow Logs are not publishing.
7. Compare AWS resources to `terraform plan` for drift.

## Cost control

NAT Gateways have hourly and data-processing charges. VPC Flow Logs published to CloudWatch also incur ingestion and storage charges. Destroy unused development infrastructure after capturing evidence when it is no longer needed.
