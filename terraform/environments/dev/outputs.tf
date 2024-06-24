output "aws_access_key_id" {
  value = module.iam.aws_access_key_id
}

output "aws_secret_access_key" {
  value     = module.iam.aws_secret_access_key
  sensitive = true
}