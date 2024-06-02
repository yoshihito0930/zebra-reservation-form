module "s3_bucket" {
  source      = "../../modules/s3"
  studio_name = var.studio_name
}

module "cloudfront_distribution" {
  source                                      = "../../modules/cloudfront"
  bucket_arn_reservationForm                  = module.s3_bucket.bucket_arn_reservationForm
  bucket_regional_domain_name_reservationForm = module.s3_bucket.bucket_regional_domain_name_reservationForm
}

module "ses" {
    source            = "../../modules/ses"
    domain_name       = "studiozebra-1st-dev.com"
    recipient-address = "yoshihito.093079@gmail.com"
}