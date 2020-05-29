resource aws_iam_role "cloudtrail_logs" {
  count              = var.cloudtrail ? 1 : 0
  name               = "cloudtrail-logs"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource aws_iam_role_policy "cloudwatch" {
  count  = var.cloudtrail ? 1 : 0
  name   = "cloudtrail-logs"
  role   = aws_iam_role.cloudtrail_logs[0].id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailPutLogEvents",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resources": "*"
        }
    ]
}
EOF
}

resource aws_cloudwatch_log_group "cloudtrail" {
  count      = var.cloudtrail ? 1 : 0
  name       = "${var.org_name}-cloudtrail"
  kms_key_id = aws_kms_key.cloudtrail[0].arn
}

resource aws_cloudtrail "audit" {
  count                      = var.cloudtrail ? 1 : 0
  name                       = "${var.org_name}-cloudtrail"
  s3_bucket_name             = var.cloudtrail_s3_bucket_id
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudtrail[0].arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_logs[0].arn
  is_multi_region_trail      = true
  is_organization_trail      = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  lifecycle {
    ignore_changes = [event_selector]
  }
}
