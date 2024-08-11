output "cloudfront_distribution_arn" {
    value = aws_cloudfront_distribution.sutudiozebra-distribution.arn
}

output "cloudfront_distribution_name" {
    value = aws_cloudfront_distribution.sutudiozebra-distribution.domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
    value = aws_cloudfront_distribution.sutudiozebra-distribution.hosted_zone_id
}