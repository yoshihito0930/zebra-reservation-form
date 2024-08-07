output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.reservation_info.endpoint
}

output "rds_instance_arn" {
  description = "The ARN for the RDS instance"
  value       = aws_db_instance.reservation_info.arn
}