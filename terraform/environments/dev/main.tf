module "iam" {
    source                        = "../../modules/iam"
    admin-user                    = var.admin-user
    cloudfront_distribution_arn   = module.cloudfront_distribution.cloudfront_distribution_arn
    studio_name                   = var.studio_name

}

module "s3_bucket" {
    source                         = "../../modules/s3"
    studio_name                    = var.studio_name
    cloudfront_distribution_arn    = module.cloudfront_distribution.cloudfront_distribution_arn
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
    source     = "../../modules/route53"
    host_name  = var.domain_name
}

module "lambda_apigateway" {
    source                          = "../../modules/lambda_apigateway"
    repository_url                  = module.ecr.repository_url
    depends_on                      = [module.ecr]
}

module "lambda_aurora" {
    source              = "../../modules/lambda_aurora"
    studio_name         = var.studio_name
}

module "network" {
    source          = "../../modules/network"
    studio_name     = var.studio_name

}

/*
module "rds" {
    source                          = "../../modules/rds"
    studio_name                     = var.studio_name
    db_identifier                   = var.db_identifier
    db_username                     = var.db_username
    db_password                     = var.db_password
    security_group_rds_sg_id        = module.network.security_group_rds_sg_id
    private_subnet_1a_id            = module.network.private_subnet_1a_id
    private_subnet_1c_id            = module.network.private_subnet_1c_id
}
*/

module "ecr" {
    source                  = "../../modules/ecr"
}

module "ecs" {
    source                              = "../../modules/ecs"
    studio_name                         = var.studio_name
    private_subnet_1a_id                = module.network.private_subnet_1a_id
    private_subnet_1c_id                = module.network.private_subnet_1c_id
    security_group_ecs_sg_id            = module.network.security_group_ecs_sg_id
    repository_url                      = module.ecr.repository_url
}