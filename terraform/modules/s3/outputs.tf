output "bucket_arn_reservationForm" {
    value = aws_s3_bucket.reservation-form.arn
}

output "bucket_regional_domain_name_reservationForm" {
    value = aws_s3_bucket.reservation-form.bucket_regional_domain_name
}