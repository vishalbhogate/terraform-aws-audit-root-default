variable "guardduty" {
  default     = true
  description = "Enable/Disables guardduty"
}

variable "cloudtrail" {
  default     = true
  description = "Enable/Disables cloudtrail"
}

variable "cloudtrail_s3_bucket_id" {
  default     = ""
  description = "S3 bucket for cloudtrail logs"
}

variable "org_name" {
  description = "Name for this organization (not actually used in API call)"
}