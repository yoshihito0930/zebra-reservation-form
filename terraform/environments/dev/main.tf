module "s3_bucket" {
  source      = "../../modules/s3"
  studio_name = var.studio_name
}

module "cloudfront_distribution" {
  source                     = "../../modules/cloudfront"
  bucket_arn_reservationForm = module.s3_bucket.bucket_arn_reservationForm
}
