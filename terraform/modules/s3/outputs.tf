output "bucket_arn_reservationForm" {
    value = aws_s3_bucket.reservation-form.arn
}

output "bucket_website_endpoint_reservationForm" {
    value = aws_s3_bucket_website_configuration.reservation-form.website_endpoint
}