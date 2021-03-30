{
    "Version": "2012-10-17",
    "Id": "Policy1615910560089",
    "Statement": [
        {
            "Sid": "2",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${oai_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "${s3_bucket}/*"
        }
    ]
}