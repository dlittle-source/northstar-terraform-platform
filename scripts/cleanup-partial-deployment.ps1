$ErrorActionPreference = "Continue"

$ProjectName = "northstar-portal-dev"
$FlowLogGroup = "/aws/vpc/northstar-portal-dev/flow-logs"
$FlowLogRole = "northstar-portal-dev-vpc-flow-logs-role"

$CloudTrailName = "northstar-portal-dev-cloudtrail"
$CloudTrailLogGroup = "/aws/cloudtrail/northstar-portal-dev"
$CloudTrailRole = "northstar-portal-dev-cloudtrail-cloudwatch-role"
$ComputeRole = "northstar-portal-dev-compute-role"
$ComputeInstanceProfile = "northstar-portal-dev-compute-instance-profile"
$CloudTrailBucketPrefix = "northstar-portal-dev-cloudtrail-"
$KmsAlias = "alias/northstar-portal-dev-platform"

Write-Host ""
Write-Host "============================================="
Write-Host " NorthStar Partial Deployment Cleanup"
Write-Host "============================================="
Write-Host ""

# ---------------------------------------------------------
# 1. Find NorthStar VPC
# ---------------------------------------------------------

Write-Host "1. Locating NorthStar VPC..."

$VpcId = aws ec2 describe-vpcs `
  --filters "Name=tag:Name,Values=$ProjectName-vpc" `
  --query "Vpcs[0].VpcId" `
  --output text `
  --no-cli-pager

if (-not $VpcId -or $VpcId -eq "None") {

    Write-Host "No NorthStar VPC found."

}
else {

    Write-Host "Found VPC: $VpcId"

    # ---------------------------------------------------------
    # 2. Delete NAT Gateways
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "2. Locating NAT Gateways..."

    $NatIds = aws ec2 describe-nat-gateways `
      --filter "Name=vpc-id,Values=$VpcId" `
      --query "NatGateways[?State!='deleted'].NatGatewayId" `
      --output text `
      --no-cli-pager

    foreach ($NatId in $NatIds -split "\s+") {

        if (-not $NatId) {
            continue
        }

        Write-Host "Found NAT Gateway: $NatId"

        $AllocationIds = aws ec2 describe-nat-gateways `
          --nat-gateway-ids $NatId `
          --query "NatGateways[0].NatGatewayAddresses[*].AllocationId" `
          --output text `
          --no-cli-pager

        Write-Host "Deleting NAT Gateway: $NatId"

        aws ec2 delete-nat-gateway `
          --nat-gateway-id $NatId `
          --no-cli-pager

        Write-Host "Waiting for NAT Gateway deletion..."

        do {

            Start-Sleep -Seconds 15

            $NatState = aws ec2 describe-nat-gateways `
              --nat-gateway-ids $NatId `
              --query "NatGateways[0].State" `
              --output text `
              --no-cli-pager 2>$null

            Write-Host "NAT state: $NatState"

        } until (
            $NatState -eq "deleted" -or
            -not $NatState -or
            $NatState -eq "None"
        )

        foreach ($AllocationId in $AllocationIds -split "\s+") {

            if ($AllocationId -and $AllocationId -ne "None") {

                Write-Host "Releasing Elastic IP: $AllocationId"

                aws ec2 release-address `
                  --allocation-id $AllocationId `
                  --no-cli-pager
            }
        }
    }

    # ---------------------------------------------------------
    # 3. Delete VPC Flow Logs
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "3. Deleting VPC Flow Logs..."

    $FlowLogIds = aws ec2 describe-flow-logs `
      --filter "Name=resource-id,Values=$VpcId" `
      --query "FlowLogs[*].FlowLogId" `
      --output text `
      --no-cli-pager

    foreach ($FlowLogId in $FlowLogIds -split "\s+") {

        if ($FlowLogId) {

            Write-Host "Deleting Flow Log: $FlowLogId"

            aws ec2 delete-flow-logs `
              --flow-log-ids $FlowLogId `
              --no-cli-pager
        }
    }

    # ---------------------------------------------------------
    # 4. Delete Application Load Balancers
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "4. Checking Application Load Balancers..."

    $LoadBalancerArns = aws elbv2 describe-load-balancers `
      --query "LoadBalancers[?VpcId=='$VpcId'].LoadBalancerArn" `
      --output text `
      --no-cli-pager 2>$null

    foreach ($LoadBalancerArn in $LoadBalancerArns -split "\s+") {

        if (-not $LoadBalancerArn -or $LoadBalancerArn -eq "None") {
            continue
        }

        Write-Host "Found load balancer: $LoadBalancerArn"

        $ListenerArns = aws elbv2 describe-listeners `
          --load-balancer-arn $LoadBalancerArn `
          --query "Listeners[*].ListenerArn" `
          --output text `
          --no-cli-pager 2>$null

        foreach ($ListenerArn in $ListenerArns -split "\s+") {

            if ($ListenerArn -and $ListenerArn -ne "None") {

                Write-Host "Deleting listener: $ListenerArn"

                aws elbv2 delete-listener `
                  --listener-arn $ListenerArn `
                  --no-cli-pager
            }
        }

        Write-Host "Deleting load balancer: $LoadBalancerArn"

        aws elbv2 delete-load-balancer `
          --load-balancer-arn $LoadBalancerArn `
          --no-cli-pager

        Write-Host "Waiting for load balancer deletion..."

        aws elbv2 wait load-balancers-deleted `
          --load-balancer-arns $LoadBalancerArn

        Write-Host "Load balancer deleted."
    }

    # ---------------------------------------------------------
    # 5. Delete Target Groups
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "5. Checking Target Groups..."

    $TargetGroupArns = aws elbv2 describe-target-groups `
      --query "TargetGroups[?VpcId=='$VpcId'].TargetGroupArn" `
      --output text `
      --no-cli-pager 2>$null

    foreach ($TargetGroupArn in $TargetGroupArns -split "\s+") {

        if ($TargetGroupArn -and $TargetGroupArn -ne "None") {

            Write-Host "Deleting target group: $TargetGroupArn"

            aws elbv2 delete-target-group `
              --target-group-arn $TargetGroupArn `
              --no-cli-pager
        }
    }

    # ---------------------------------------------------------
    # 6. Terminate EC2 Instances
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "6. Checking EC2 instances..."

    $InstanceIds = aws ec2 describe-instances `
      --filters `
        "Name=vpc-id,Values=$VpcId" `
        "Name=instance-state-name,Values=pending,running,stopping,stopped" `
      --query "Reservations[*].Instances[*].InstanceId" `
      --output text `
      --no-cli-pager

    foreach ($InstanceId in $InstanceIds -split "\s+") {

        if (-not $InstanceId -or $InstanceId -eq "None") {
            continue
        }

        Write-Host "Terminating EC2 instance: $InstanceId"

        aws ec2 terminate-instances `
          --instance-ids $InstanceId `
          --no-cli-pager

        Write-Host "Waiting for EC2 termination..."

        aws ec2 wait instance-terminated `
          --instance-ids $InstanceId

        Write-Host "EC2 instance terminated."
    }

    # ---------------------------------------------------------
    # 7. Wait for Dependent ENIs
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "7. Waiting for dependent network interfaces..."

    do {

        $RemainingEnis = aws ec2 describe-network-interfaces `
          --filters "Name=vpc-id,Values=$VpcId" `
          --query "NetworkInterfaces[?InterfaceType!='nat_gateway'].NetworkInterfaceId" `
          --output text `
          --no-cli-pager 2>$null

        if ($RemainingEnis -and $RemainingEnis -ne "None") {

            Write-Host "Waiting for ENIs: $RemainingEnis"
            Start-Sleep -Seconds 10
        }

    } until (
        -not $RemainingEnis -or
        $RemainingEnis -eq "None"
    )

    Write-Host "Dependent network interfaces removed."

    # ---------------------------------------------------------
    # 8. Delete Subnets
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "8. Deleting subnets..."

    $SubnetIds = aws ec2 describe-subnets `
      --filters "Name=vpc-id,Values=$VpcId" `
      --query "Subnets[*].SubnetId" `
      --output text `
      --no-cli-pager

    foreach ($SubnetId in $SubnetIds -split "\s+") {

        if ($SubnetId) {

            Write-Host "Deleting subnet: $SubnetId"

            aws ec2 delete-subnet `
              --subnet-id $SubnetId `
              --no-cli-pager
        }
    }

    # ---------------------------------------------------------
    # 9. Delete Route Table Associations
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "9. Removing route table associations..."

    $RouteTableIds = aws ec2 describe-route-tables `
      --filters "Name=vpc-id,Values=$VpcId" `
      --query "RouteTables[*].RouteTableId" `
      --output text `
      --no-cli-pager

    foreach ($RouteTableId in $RouteTableIds -split "\s+") {

        if (-not $RouteTableId) {
            continue
        }

        $AssociationIds = aws ec2 describe-route-tables `
          --route-table-ids $RouteTableId `
          --query "RouteTables[0].Associations[?Main!=``true``].RouteTableAssociationId" `
          --output text `
          --no-cli-pager

        foreach ($AssociationId in $AssociationIds -split "\s+") {

            if ($AssociationId -and $AssociationId -ne "None") {

                Write-Host "Disassociating route table: $AssociationId"

                aws ec2 disassociate-route-table `
                  --association-id $AssociationId `
                  --no-cli-pager
            }
        }
    }

    # ---------------------------------------------------------
    # 10. Delete Custom Route Tables
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "10. Deleting custom route tables..."

    $MainRouteTableId = aws ec2 describe-route-tables `
      --filters `
        "Name=vpc-id,Values=$VpcId" `
        "Name=association.main,Values=true" `
      --query "RouteTables[0].RouteTableId" `
      --output text `
      --no-cli-pager

    foreach ($RouteTableId in $RouteTableIds -split "\s+") {

        if (
            $RouteTableId -and
            $RouteTableId -ne $MainRouteTableId
        ) {

            Write-Host "Deleting route table: $RouteTableId"

            aws ec2 delete-route-table `
              --route-table-id $RouteTableId `
              --no-cli-pager
        }
    }

    # ---------------------------------------------------------
    # 11. Remove Security Group References
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "11. Removing security group references..."

    $SecurityGroupIds = aws ec2 describe-security-groups `
      --filters "Name=vpc-id,Values=$VpcId" `
      --query "SecurityGroups[?GroupName!='default'].GroupId" `
      --output text `
      --no-cli-pager

    foreach ($SecurityGroupId in $SecurityGroupIds -split "\s+") {

        if (-not $SecurityGroupId) {
            continue
        }

        $IngressRuleIds = aws ec2 describe-security-group-rules `
          --filters "Name=group-id,Values=$SecurityGroupId" `
          --query "SecurityGroupRules[?IsEgress==``false`` && ReferencedGroupInfo.GroupId!=null].SecurityGroupRuleId" `
          --output text `
          --no-cli-pager

        foreach ($RuleId in $IngressRuleIds -split "\s+") {

            if ($RuleId -and $RuleId -ne "None") {

                Write-Host "Revoking SG reference rule: $RuleId"

                aws ec2 revoke-security-group-ingress `
                  --group-id $SecurityGroupId `
                  --security-group-rule-ids $RuleId `
                  --no-cli-pager
            }
        }
    }

    # ---------------------------------------------------------
    # 12. Delete Custom Security Groups
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "12. Deleting custom security groups..."

    foreach ($SecurityGroupId in $SecurityGroupIds -split "\s+") {

        if ($SecurityGroupId) {

            Write-Host "Deleting security group: $SecurityGroupId"

            aws ec2 delete-security-group `
              --group-id $SecurityGroupId `
              --no-cli-pager
        }
    }

    # ---------------------------------------------------------
    # 13. Detach/Delete Internet Gateway
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "13. Removing Internet Gateway..."

    $InternetGatewayIds = aws ec2 describe-internet-gateways `
      --filters "Name=attachment.vpc-id,Values=$VpcId" `
      --query "InternetGateways[*].InternetGatewayId" `
      --output text `
      --no-cli-pager

    foreach ($InternetGatewayId in $InternetGatewayIds -split "\s+") {

        if ($InternetGatewayId) {

            Write-Host "Detaching Internet Gateway: $InternetGatewayId"

            aws ec2 detach-internet-gateway `
              --internet-gateway-id $InternetGatewayId `
              --vpc-id $VpcId `
              --no-cli-pager

            Write-Host "Deleting Internet Gateway: $InternetGatewayId"

            aws ec2 delete-internet-gateway `
              --internet-gateway-id $InternetGatewayId `
              --no-cli-pager
        }
    }

    # ---------------------------------------------------------
    # 14. Delete VPC
    # ---------------------------------------------------------

    Write-Host ""
    Write-Host "14. Deleting VPC: $VpcId"

    aws ec2 delete-vpc `
      --vpc-id $VpcId `
      --no-cli-pager
}

# ---------------------------------------------------------
# 15. Delete Flow Logs CloudWatch Log Group
# ---------------------------------------------------------

Write-Host ""
Write-Host "15. Checking Flow Logs CloudWatch Log Group..."

$ExistingFlowLogGroup = aws logs describe-log-groups `
  --log-group-name-prefix $FlowLogGroup `
  --query "logGroups[?logGroupName=='$FlowLogGroup'].logGroupName" `
  --output text `
  --no-cli-pager

if ($ExistingFlowLogGroup) {

    Write-Host "Deleting log group: $FlowLogGroup"

    aws logs delete-log-group `
      --log-group-name $FlowLogGroup `
      --no-cli-pager
}

# ---------------------------------------------------------
# 16. Delete Flow Logs IAM Role
# ---------------------------------------------------------

Write-Host ""
Write-Host "16. Checking Flow Logs IAM role..."

$RoleExists = aws iam get-role `
  --role-name $FlowLogRole `
  --query "Role.RoleName" `
  --output text `
  --no-cli-pager 2>$null

if ($RoleExists) {

    $RolePolicies = aws iam list-role-policies `
      --role-name $FlowLogRole `
      --query "PolicyNames" `
      --output text `
      --no-cli-pager

    foreach ($PolicyName in $RolePolicies -split "\s+") {

        if ($PolicyName) {

            Write-Host "Deleting IAM inline policy: $PolicyName"

            aws iam delete-role-policy `
              --role-name $FlowLogRole `
              --policy-name $PolicyName `
              --no-cli-pager
        }
    }

    Write-Host "Deleting IAM role: $FlowLogRole"

    aws iam delete-role `
      --role-name $FlowLogRole `
      --no-cli-pager
}
else {

    Write-Host "Flow Logs IAM role does not exist."
}

# ---------------------------------------------------------
# 17. Delete Compute Instance Profile and IAM Role
# ---------------------------------------------------------

Write-Host ""
Write-Host "17. Checking Compute IAM resources..."

$ComputeInstanceProfileExists = aws iam get-instance-profile `
  --instance-profile-name $ComputeInstanceProfile `
  --query "InstanceProfile.InstanceProfileName" `
  --output text `
  --no-cli-pager 2>$null

if ($ComputeInstanceProfileExists) {

    $ProfileRoles = aws iam get-instance-profile `
      --instance-profile-name $ComputeInstanceProfile `
      --query "InstanceProfile.Roles[*].RoleName" `
      --output text `
      --no-cli-pager

    foreach ($ProfileRole in $ProfileRoles -split "\s+") {

        if ($ProfileRole) {
            Write-Host "Removing role from instance profile: $ProfileRole"

            aws iam remove-role-from-instance-profile `
              --instance-profile-name $ComputeInstanceProfile `
              --role-name $ProfileRole `
              --no-cli-pager
        }
    }

    Write-Host "Deleting compute instance profile: $ComputeInstanceProfile"

    aws iam delete-instance-profile `
      --instance-profile-name $ComputeInstanceProfile `
      --no-cli-pager
}
else {

    Write-Host "Compute instance profile does not exist."
}

$ComputeRoleExists = aws iam get-role `
  --role-name $ComputeRole `
  --query "Role.RoleName" `
  --output text `
  --no-cli-pager 2>$null

if ($ComputeRoleExists) {

    $AttachedPolicies = aws iam list-attached-role-policies `
      --role-name $ComputeRole `
      --query "AttachedPolicies[*].PolicyArn" `
      --output text `
      --no-cli-pager

    foreach ($PolicyArn in $AttachedPolicies -split "\s+") {

        if ($PolicyArn) {
            Write-Host "Detaching managed policy: $PolicyArn"

            aws iam detach-role-policy `
              --role-name $ComputeRole `
              --policy-arn $PolicyArn `
              --no-cli-pager
        }
    }

    $ComputeInlinePolicies = aws iam list-role-policies `
      --role-name $ComputeRole `
      --query "PolicyNames" `
      --output text `
      --no-cli-pager

    foreach ($PolicyName in $ComputeInlinePolicies -split "\s+") {

        if ($PolicyName) {
            Write-Host "Deleting compute inline policy: $PolicyName"

            aws iam delete-role-policy `
              --role-name $ComputeRole `
              --policy-name $PolicyName `
              --no-cli-pager
        }
    }

    Write-Host "Deleting compute IAM role: $ComputeRole"

    aws iam delete-role `
      --role-name $ComputeRole `
      --no-cli-pager
}
else {

    Write-Host "Compute IAM role does not exist."
}

# ---------------------------------------------------------
# 18. Delete CloudTrail Trail
# ---------------------------------------------------------

Write-Host ""
Write-Host "18. Checking CloudTrail trail..."

$ExistingTrail = aws cloudtrail describe-trails `
  --trail-name-list $CloudTrailName `
  --query "trailList[?Name=='$CloudTrailName'].Name | [0]" `
  --output text `
  --no-cli-pager 2>$null

if ($ExistingTrail -and $ExistingTrail -ne "None") {

    Write-Host "Stopping CloudTrail logging: $CloudTrailName"

    aws cloudtrail stop-logging `
      --name $CloudTrailName `
      --no-cli-pager 2>$null

    Write-Host "Deleting CloudTrail trail: $CloudTrailName"

    aws cloudtrail delete-trail `
      --name $CloudTrailName `
      --no-cli-pager
}
else {

    Write-Host "CloudTrail trail does not exist."
}

# ---------------------------------------------------------
# 19. Delete CloudTrail CloudWatch Log Group
# ---------------------------------------------------------

Write-Host ""
Write-Host "19. Checking CloudTrail CloudWatch Log Group..."

$ExistingCloudTrailLogGroup = aws logs describe-log-groups `
  --log-group-name-prefix $CloudTrailLogGroup `
  --query "logGroups[?logGroupName=='$CloudTrailLogGroup'].logGroupName" `
  --output text `
  --no-cli-pager

if ($ExistingCloudTrailLogGroup) {

    Write-Host "Deleting CloudTrail log group: $CloudTrailLogGroup"

    aws logs delete-log-group `
      --log-group-name $CloudTrailLogGroup `
      --no-cli-pager
}

# ---------------------------------------------------------
# 20. Delete CloudTrail IAM Role
# ---------------------------------------------------------

Write-Host ""
Write-Host "20. Checking CloudTrail IAM role..."

$CloudTrailRoleExists = aws iam get-role `
  --role-name $CloudTrailRole `
  --query "Role.RoleName" `
  --output text `
  --no-cli-pager 2>$null

if ($CloudTrailRoleExists) {

    $CloudTrailPolicies = aws iam list-role-policies `
      --role-name $CloudTrailRole `
      --query "PolicyNames" `
      --output text `
      --no-cli-pager

    foreach ($PolicyName in $CloudTrailPolicies -split "\s+") {

        if ($PolicyName) {

            Write-Host "Deleting CloudTrail inline policy: $PolicyName"

            aws iam delete-role-policy `
              --role-name $CloudTrailRole `
              --policy-name $PolicyName `
              --no-cli-pager
        }
    }

    Write-Host "Deleting CloudTrail IAM role: $CloudTrailRole"

    aws iam delete-role `
      --role-name $CloudTrailRole `
      --no-cli-pager
}
else {

    Write-Host "CloudTrail IAM role does not exist."
}

# ---------------------------------------------------------
# 21. Delete CloudTrail S3 Bucket
# ---------------------------------------------------------

Write-Host ""
Write-Host "21. Checking CloudTrail S3 bucket..."

$CloudTrailBuckets = aws s3api list-buckets `
  --query "Buckets[?starts_with(Name, '$CloudTrailBucketPrefix')].Name" `
  --output text `
  --no-cli-pager

foreach ($BucketName in $CloudTrailBuckets -split "\s+") {

    if (-not $BucketName) {
        continue
    }

    Write-Host "Found CloudTrail bucket: $BucketName"
    Write-Host "Removing all object versions and delete markers..."

    do {

        $VersionDataJson = aws s3api list-object-versions `
          --bucket $BucketName `
          --output json `
          --no-cli-pager

        $VersionData = $VersionDataJson | ConvertFrom-Json

        $ItemsRemoved = 0

        foreach ($Version in $VersionData.Versions) {

            Write-Host "Deleting object version: $($Version.Key)"

            aws s3api delete-object `
              --bucket $BucketName `
              --key $Version.Key `
              --version-id $Version.VersionId `
              --no-cli-pager

            $ItemsRemoved++
        }

        foreach ($Marker in $VersionData.DeleteMarkers) {

            Write-Host "Deleting delete marker: $($Marker.Key)"

            aws s3api delete-object `
              --bucket $BucketName `
              --key $Marker.Key `
              --version-id $Marker.VersionId `
              --no-cli-pager

            $ItemsRemoved++
        }

        if ($ItemsRemoved -gt 0) {
            Write-Host "Removed $ItemsRemoved bucket item(s). Checking again..."
            Start-Sleep -Seconds 3
        }

    } while ($ItemsRemoved -gt 0)

    Write-Host "Bucket is empty."

    Write-Host "Deleting CloudTrail bucket: $BucketName"

    aws s3api delete-bucket `
      --bucket $BucketName `
      --no-cli-pager
}

# ---------------------------------------------------------
# 22. Delete KMS Alias
# ---------------------------------------------------------

Write-Host ""
Write-Host "22. Checking KMS alias..."

$KmsTargetKeyId = aws kms list-aliases `
  --query "Aliases[?AliasName=='$KmsAlias'].TargetKeyId | [0]" `
  --output text `
  --no-cli-pager

if ($KmsTargetKeyId -and $KmsTargetKeyId -ne "None") {

    Write-Host "Deleting KMS alias: $KmsAlias"

    aws kms delete-alias `
      --alias-name $KmsAlias `
      --no-cli-pager

    Write-Host "Scheduling KMS key deletion: $KmsTargetKeyId"

    aws kms schedule-key-deletion `
      --key-id $KmsTargetKeyId `
      --pending-window-in-days 7 `
      --no-cli-pager
}
else {

    Write-Host "KMS alias does not exist."
}

# ---------------------------------------------------------
# Final Verification
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================="
Write-Host " Cleanup finished - running verification"
Write-Host "============================================="
Write-Host ""

Write-Host "Remaining NorthStar VPCs:"

aws ec2 describe-vpcs `
  --filters "Name=tag:Name,Values=$ProjectName-vpc" `
  --query "Vpcs[*].[VpcId,State]" `
  --output table `
  --no-cli-pager

Write-Host ""

Write-Host "Remaining NorthStar Application Load Balancers:"

$VerificationVpcId = aws ec2 describe-vpcs `
  --filters "Name=tag:Name,Values=$ProjectName-vpc" `
  --query "Vpcs[0].VpcId" `
  --output text `
  --no-cli-pager 2>$null

if ($VerificationVpcId -and $VerificationVpcId -ne "None") {

    aws elbv2 describe-load-balancers `
      --query "LoadBalancers[?VpcId=='$VerificationVpcId'].[LoadBalancerName,State.Code]" `
      --output table `
      --no-cli-pager

    Write-Host ""
    Write-Host "Remaining NorthStar Target Groups:"

    aws elbv2 describe-target-groups `
      --query "TargetGroups[?VpcId=='$VerificationVpcId'].[TargetGroupName,TargetGroupArn]" `
      --output table `
      --no-cli-pager

    Write-Host ""
    Write-Host "Remaining NorthStar EC2 instances:"

    aws ec2 describe-instances `
      --filters `
        "Name=vpc-id,Values=$VerificationVpcId" `
        "Name=instance-state-name,Values=pending,running,stopping,stopped" `
      --query "Reservations[*].Instances[*].[InstanceId,State.Name]" `
      --output table `
      --no-cli-pager

    Write-Host ""
    Write-Host "Remaining NorthStar network interfaces:"

    aws ec2 describe-network-interfaces `
      --filters "Name=vpc-id,Values=$VerificationVpcId" `
      --query "NetworkInterfaces[*].[NetworkInterfaceId,Status,InterfaceType,Description]" `
      --output table `
      --no-cli-pager

    Write-Host ""
    Write-Host "Remaining NorthStar custom security groups:"

    aws ec2 describe-security-groups `
      --filters "Name=vpc-id,Values=$VerificationVpcId" `
      --query "SecurityGroups[?GroupName!='default'].[GroupId,GroupName]" `
      --output table `
      --no-cli-pager
}

Write-Host ""

Write-Host "Remaining NorthStar NAT Gateways:"

aws ec2 describe-nat-gateways `
  --filter "Name=tag:Name,Values=$ProjectName*" `
  --query "NatGateways[?State=='available' || State=='pending' || State=='deleting'].[NatGatewayId,VpcId,State]" `
  --output table `
  --no-cli-pager

Write-Host ""

Write-Host "Remaining Flow Logs log group:"

aws logs describe-log-groups `
  --log-group-name-prefix $FlowLogGroup `
  --query "logGroups[*].logGroupName" `
  --output table `
  --no-cli-pager

Write-Host ""

Write-Host "Remaining Compute instance profile:"

aws iam get-instance-profile `
  --instance-profile-name $ComputeInstanceProfile `
  --query "InstanceProfile.InstanceProfileName" `
  --output text `
  --no-cli-pager 2>$null

Write-Host ""

Write-Host "Remaining Compute IAM role:"

aws iam get-role `
  --role-name $ComputeRole `
  --query "Role.RoleName" `
  --output text `
  --no-cli-pager 2>$null

Write-Host ""

Write-Host "Remaining CloudTrail trail:"

aws cloudtrail describe-trails `
  --trail-name-list $CloudTrailName `
  --query "trailList[*].[Name,TrailARN]" `
  --output table `
  --no-cli-pager

Write-Host ""

Write-Host "Remaining CloudTrail log group:"

aws logs describe-log-groups `
  --log-group-name-prefix $CloudTrailLogGroup `
  --query "logGroups[*].logGroupName" `
  --output table `
  --no-cli-pager

Write-Host ""

Write-Host "Remaining CloudTrail IAM role:"

aws iam get-role `
  --role-name $CloudTrailRole `
  --query "Role.RoleName" `
  --output text `
  --no-cli-pager 2>$null

Write-Host ""

Write-Host "Remaining CloudTrail S3 bucket:"

aws s3api list-buckets `
  --query "Buckets[?starts_with(Name, '$CloudTrailBucketPrefix')].Name" `
  --output table `
  --no-cli-pager

Write-Host ""

Write-Host "Remaining KMS alias:"

aws kms list-aliases `
  --query "Aliases[?AliasName=='$KmsAlias'].[AliasName,TargetKeyId]" `
  --output table `
  --no-cli-pager

Write-Host ""

Write-Host "NorthStar partial deployment cleanup complete."