### cloudfront log
resource "aws_s3_bucket" "cloudfront-log" {
    bucket = "${var.studio_name}-cloudfront-log"
}

### reservation-form
resource "aws_s3_bucket" "reservation-form" {
    bucket = "${var.studio_name}-reservation-form"
}

# object
resource "aws_s3_object" "reserv_form" {
  bucket = aws_s3_bucket.reservation-form.id
  key    = "reservation-form/"
}

resource "aws_s3_object" "form_builder" {
  bucket = aws_s3_bucket.reservation-form.id
  key    = "form-builder/"
}

# CORSルール
resource "aws_s3_bucket_cors_configuration" "cors-rule" {
    bucket = aws_s3_bucket.reservation-form.id

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "HEAD", "POST", "PUT"]
        allowed_origins = ["https://${var.host_name}"]
        max_age_seconds = "3000"
    }
}

# S3 パブリックアクセスブロックの設定
resource "aws_s3_bucket_public_access_block" "block_reservation-form" {
    bucket = aws_s3_bucket.reservation-form.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "aws_s3_bucket_policy" {
  bucket = aws_s3_bucket.reservation-form.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.reservation-form.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "reservation-form" {
  bucket = aws_s3_bucket.reservation-form.id

  index_document {
    suffix = "index.html"
  }
}