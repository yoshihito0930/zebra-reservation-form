variable "admin-user" {
  description = "The user name of administrator (e.g., zebra-admin)"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  type        = string
}