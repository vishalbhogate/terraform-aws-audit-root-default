#KMS customer master key
resource aws_kms_key "cloudtrail" {
  count                   = var.cloudtrail ? 1 : 0
  deletion_window_in_days = 7
  description             = "Cloudtrail Log Encryption Key"
  enable_key_rotation     = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable Iam uaser permission for KMS",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          ]
      },
      "Action": "kms:*",
      "Resource": "*"
  },
  {
      "Sid": "Allow CloudTrail to encrypt logs",
      "Effect": "Allow",
      "Principal": {
          "Service" : "cloudtrail.amazonaws.com"
      },
      "Action": "kms:GenerateDataKey",
      "Resource": "*",
      "Condition": {
                "StringLike": {
                    "kms:EncryptionContext:aws:cloudtrail:arn":["arn:aws:cloudtrail:*:975816917933:trail/*"]
                }
            }
  },
  {
      "Sid": "Allow CloudWatch Access",
      "Effect": "Allow",
      "Principal": {
          "Service": "logs.amazonaws.com"
      },
      "Action": [
        "kms:Describe*",
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey",
        "kms:DescribeKey",
        "kms:ReEncrypt*"
      ],
      "Resource": "*"
  },
  {
      "Sid": "Allow Describe Key access cloudtrail & Lambda",
      "Effect": "Allow",
      "Principal": {
          "Service": ["cloudtrail.amazonaws.com", "lambda.amazonaws.com"]
      },
      "Action": "*",
      "Resource": "*"
  }

  ]
}
POLICY
}
