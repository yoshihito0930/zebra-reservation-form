output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
  description = "The endpoint of the RDS instance"
}