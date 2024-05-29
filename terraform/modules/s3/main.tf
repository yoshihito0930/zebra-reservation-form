### cloudfront log
resource "aws_s3_bucket" "cloudfront-log" {
    bucket = "${var.studio_name}-cloudfront-log"
}
###

### reservation-form
resource "aws_s3_bucket" "reservation-form" {
    bucket = "${var.studio_name}-reservation-form"
}

# CORSルール
resource "aws_s3_bucket_cors_configuration" "cors-rule" {
    bucket = aws_s3_bucket.reservation-form.id

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "HEAD", "POST", "PUT"]
        allowed_origins = ["https://reservation-form.studiozebra-1st-dev.com"]
        max_age_seconds = "3000"
    }
}

# S3 パブリックアクセスブロックの設定
resource "aws_s3_bucket_public_access_block" "block_reservation-form" {
    bucket = aws_s3_bucket.reservation-form.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "allow_cloudfront_service_principal" {
    bucket = aws_s3_bucket.reservation-form.id
    policy = data.aws_iam_policy_document.allow_cloudfront_service_principal.json
}

data "aws_iam_policy_document" "allow_cloudfront_service_principal" {
    statement {
        sid             = "AllowCloudFrontServicePrincipal"

        principals {
            type        = "Service"
            identifiers = ["cloudfront.amazonaws.com"]
        }

        actions         = [
            "s3:GetObject",
        ]

        resources       = [
            "${aws_s3_bucket.reservation-form.arn}/*",
        ]

        condition {
            test        = "StringEquals"
            variable    = "AWS:SourceArn"
            values      = [
                "arn:aws:cloudfront::807357942906:distribution/E36NOONM5TQTGN"
            ]
        }
    }
}
###