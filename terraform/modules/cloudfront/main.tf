# CloudFront
locals {
  s3_origin_id = "studiozebra-1st-reservation-form.s3.ap-northeast-1.amazonaws.com"
}

resource "aws_cloudfront_distribution" "sutudiozebra-distribution" {
  origin {
    domain_name              = var.bucket_regional_domain_name_reservationForm
    origin_access_control_id = "ECRGSSF7MPJXW"
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Studiozebra reservation form"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "studiozebra-1st-cloudfront-log.s3.amazonaws.com"
  }

  aliases = ["*.studiozebra-1st-dev.com"]

  default_cache_behavior {
    cache_policy_id   = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    compress               = true
  }
  
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }

  # tags = {
  #   Environment = "production"
  # }

  viewer_certificate {
    cloudfront_default_certificate = "false"
    acm_certificate_arn            = var.acm_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}