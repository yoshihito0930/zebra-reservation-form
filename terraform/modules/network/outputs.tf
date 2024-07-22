output "security_group_rds_endpoint_id" {
  value = aws_security_group.rds_endpoint_sg.id
  description = "The security groupe of the RDS Endpoint"
}

output "private_subnet_1a" {
  value = aws_subnet.private_1a.id
  description = "The private subnet of the ap-northeast-1a"
}

output "private_subnet_1c" {
  value = aws_subnet.private_1c.id
  description = "The private subnet of the ap-northeast-1c"
}