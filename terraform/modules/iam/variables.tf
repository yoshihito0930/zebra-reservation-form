variable "admin-user" {
  description = "The user name of administrator (e.g., zebra-admin)"
  type        = string
}

variable "githubAction-user" {
  description = "The user name who act github actions (e.g., zebra-github-s3)"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  type        = string
}