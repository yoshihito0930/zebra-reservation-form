output "lambda_functions_repository_url" {
  value       = aws_ecr_repository.zebra_reservation_form.repository_url
  description = "The repository uri of the lambda functions"
}

output "port_forwarder_repository_url" {
  value       = aws_ecr_repository.port_forwarder.repository_url
  description = "The repository uri of the port forwarder"
}