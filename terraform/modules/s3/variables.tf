variable "studio_name" {
  description = "The name of studio (e.g., studio-zebra)"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  type        = string
}

variable "host_name" {
  description = "The host name of studio (e.g., studiozebra-1st-dev.com)"
  type        = string
}