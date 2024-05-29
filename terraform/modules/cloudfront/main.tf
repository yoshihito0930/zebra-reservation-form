# CloudFront
resource "aws_s3_bucket_acl" "studiozebra_acl" {
  bucket = aws_s3_bucket.studiozebra.id
  acl    = "private"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_origin_access_control" "studio_zebra" {
  name                              = "studiozebra-1st-reservation-form.s3.ap-northeast-1.amazonaws.com"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.studiozebra.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
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
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 1
    default_ttl            = 86400
    max_ttl                = 31536000
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
    acm_certificate_arn            = "arn:aws:acm:us-east-1:807357942906:certificate/8275ca6f-b3a6-450c-ad04-ab4a3bf31032"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
data "aws_iam_policy_document" "allow_cloudfront_service_principal" {
  statement {
    sid           = "AllowCloudFrontServicePrincipal"

    actions       = ["s3:GetObject"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources     = ["${aws_s3_bucket.studiozebra.arn}/*"]

    condition {
        test      = "StringEquals"
        variable  = "aws:SourceArn"
        values    = ["${aws_cloudfront_distribution.studiozebra.arn}"]
    }
  }
}