module "iam" {
    source                        = "../../modules/iam"
    admin-user                    = var.admin-user
    cloudfront_distribution_arn    = module.cloudfront_distribution.cloudfront_distribution_arn
}

module "s3_bucket" {
    source      = "../../modules/s3"
    studio_name = var.studio_name
}

module "cloudfront_distribution" {
    source                                      = "../../modules/cloudfront"
    bucket_arn_reservationForm                  = module.s3_bucket.bucket_arn_reservationForm
    bucket_regional_domain_name_reservationForm = module.s3_bucket.bucket_regional_domain_name_reservationForm
    acm_arn                                     = module.route53.acm_arn
}

module "ses" {
    source            = "../../modules/ses"
    domain_name       = var.domain_name
    recipient-address = var.recipient-address
}

module "route53" {
    source            = "../../modules/route53"
    host_name         = var.domain_name
}

module "lambda_apigateway" {
    source            = "../../modules/lambda_apigateway"
}