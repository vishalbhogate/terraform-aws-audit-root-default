output "guardduty_detector_id" {
  value       = try(aws_guardduty_detector.master[0].id, "")
  description = "GuardDuty Detector ID of master account"
}