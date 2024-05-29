module "s3_bucket" {
  source      = "../../modules/s3"
  studio_name = var.studio_name
}