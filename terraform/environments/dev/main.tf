# S3バケット
resource "aws_s3_bucket" "studiozebra" {
  bucket = "studiozebra-1st-reservation-form"
}

# S3バケット CORSルール
resource "aws_s3_bucket_cors_configuration" "cors_studiozebra" {
    bucket = "aws_s3_bucket.studiozebra-1st-reservation-form.bucket"

    cors_rule {
        allowed_headers = [*]
        allowed_methods = ["GET", "HEAD", "POST", "PUT"]
        allowed_origins = ["https://reservation-form.studiozebra-1st-dev.com"]
        max_age_seconds = ["3000"]
    }
}

# S3 パブリックアクセスブロックの設定
resource "aws_s3_bucket_public_access_block" "block_studiozebra" {
    bucket = aws_s3_bucket.studiozebra.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "allow_cloudfront_service_principal" {
  bucket = aws_s3_bucket.studiozebra.id
  policy = data.aws_iam_policy_document.allow_cloudfront_service_principal.json
}

data "aws_iam_policy_document" "allow_cloudfront_service_principal" {
  statement {
    sid           = "AllowCloudFrontServicePrincipal"

    actions       = "s3:GetObject"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources     = "${aws_s3_bucket.studiozebra.arn}/*"

    condition {
        test     = "StringEquals"
        variable = "aws:SourceArn"
        values   = [aws_cloudfront_distribution.studiozebra.arn]        
    }
  }
}