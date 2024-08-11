# CloudFront
locals {
  s3_origin_id = "studiozebra-1st-reservation-form.s3-website-ap-northeast-1.amazonaws.com"
}

resource "aws_cloudfront_distribution" "sutudiozebra-distribution" {
  origin {
    domain_name              = var.bucket_website_endpoint_reservationForm
    origin_id                = local.s3_origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Studiozebra reservation form"

  logging_config {
    include_cookies = false
    bucket          = "studiozebra-1st-cloudfront-log.s3.amazonaws.com"
  }

  aliases = ["studiozebra-1st-dev.com", "*.studiozebra-1st-dev.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 300
    max_ttl                = 1200
    min_ttl                = 0
    compress               = true
  }
  
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  # /reservation-form/* パスに対する ordered_cache_behavior
  ordered_cache_behavior {
    path_pattern     = "/reservation-form/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 300
    max_ttl                = 1200
    compress               = true
  }
}