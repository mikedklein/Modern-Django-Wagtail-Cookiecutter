{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${s3_bucket}",
        "${s3_bucket}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ConnectionsUseAccess",
      "Effect": "Allow",
      "Action": [
          "codestar-connections:UseConnection"
      ],
      "Resource": ["${codestar_connection}"]
    }
  ]
}