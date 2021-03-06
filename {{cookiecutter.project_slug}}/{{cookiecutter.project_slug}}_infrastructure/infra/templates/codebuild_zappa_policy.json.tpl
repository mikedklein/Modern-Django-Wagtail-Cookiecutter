{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "iam:GetPolicyVersion",
        "cloudformation:DeleteStackInstances",
        "events:EnableRule",
        "sqs:ReceiveMessage",
        "logs:*",
        "cloudformation:DescribeStackResource",
        "iam:PutRolePolicy",
        "cloudformation:UpdateStackSet",
        "cloudformation:CreateChangeSet",
        "xray:PutTraceSegments",
        "cloudformation:ContinueUpdateRollback",
        "events:ListRuleNamesByTarget",
        "cloudformation:DescribeStackEvents",
        "iam:ListAttachedRolePolicies",
        "events:ListRules",
        "cloudformation:UpdateStack",
        "events:RemoveTargets",
        "s3:HeadBucket",
        "iam:ListRolePolicies",
        "apigateway:GET",
        "cloudformation:DescribeChangeSet",
        "events:ListTargetsByRule",
        "cloudformation:CreateStackSet",
        "cloudformation:ExecuteChangeSet",
        "cloudformation:ListStackResources",
        "events:PutEvents",
        "iam:GetRole",
        "events:DescribeRule",
        "s3:PutAccountPublicAccessBlock",
        "iam:GetPolicy",
        "cloudformation:DescribeStackInstance",
        "sqs:SendMessage",
        "cloudformation:DescribeStackResources",
        "cloudformation:SignalResource",
        "cloudformation:DescribeStacks",
        "cloudformation:DescribeStackResourceDrifts",
        "cloudwatch:*",
        "cloudformation:GetTemplate",
        "dynamodb:DescribeReservedCapacity",
        "cloudformation:DeleteStack",
        "apigateway:POST",
        "ec2:DescribeSubnets",
        "iam:GetRolePolicy",
        "cloudformation:ValidateTemplate",
        "cloudformation:CreateUploadBucket",
        "cloudformation:CancelUpdateStack",
        "tag:GetResources",
        "xray:PutTelemetryRecords",
        "cloudformation:UpdateStackInstances",
        "events:PutRule",
        "dynamodb:PurchaseReservedCapacityOfferings",
        "dynamodb:ListTagsOfResource",
        "cloudformation:UpdateTerminationProtection",
        "cloudformation:CreateStackInstances",
        "cloudformation:DeleteChangeSet",
        "apigateway:DELETE",
        "iam:PassRole",
        "dynamodb:DescribeReservedCapacityOfferings",
        "dynamodb:TagResource",
        "apigateway:PATCH",
        "cloudformation:StopStackSetOperation",
        "dynamodb:DescribeLimits",
        "events:DisableRule",
        "cloudformation:SetStackPolicy",
        "sqs:ListQueues",
        "dynamodb:UntagResource",
        "apigateway:PUT",
        "iam:ListRoles",
        "dynamodb:DescribeTimeToLive",
        "cloudformation:DeleteStackSet",
        "ec2:DescribeSecurityGroups",
        "dynamodb:ListStreams",
        "events:DeleteRule",
        "events:PutTargets",
        "s3:GetAccountPublicAccessBlock",
        "s3:ListAllMyBuckets",
        "cloudformation:DescribeStackSet",
        "cloudformation:CreateStack",
        "ec2:DescribeVpcs",
        "lambda:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "dynamodb:DescribeTable"
      ],
      "Resource": "*"
    },
    {
      "Sid": "VisualEditor2",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}