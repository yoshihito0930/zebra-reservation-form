variable "host_name" {
  description = "The host name of studio (e.g., studiozebra-1st-dev.com)"
  type        = string
}

variable "cloudfront_distribution_name" {
  description = "The domain name of cloudfront distribution"
  type        = string
}

variable "cloudfront_distribution_hosted_zone_id" {
  description = "The hosted zone id of cloudfront distribution"
  type        = string
}