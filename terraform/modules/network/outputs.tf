output "security_group_aurora_mysql_id" {
  value = aws_security_group.aurora_mysql_sg.id
  description = "The security groupe of the RDS Endpoint"
}

output "fargate_sg_id" {
  value = aws_security_group.aurora_mysql_sg.id
  description = "The security groupe id of the Fargate"
}

output "private_subnet_1a_id" {
  value = aws_subnet.private_1a.id
  description = "The private subnet id of the ap-northeast-1a"
}

output "private_subnet_1c_id" {
  value = aws_subnet.private_1c.id
  description = "The private subnet id of the ap-northeast-1c"
}