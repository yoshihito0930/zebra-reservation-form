variable "admin-user" {
  description = "The user name of administrator (e.g., zebra-admin)"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  type        = string
}

variable "studio_name" {
  description = "The name of studio (e.g., studio-zebra)"
  type        = string
}