output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "security_group_rds_sg_id" {
  value = aws_security_group.rds_sg.id
  description = "The security groupe of the RDS"
}

output "security_group_ecs_sg_id" {
  value = aws_security_group.ecs_security_group.id
  description = "The security groupe of the ECS"
}

output "public_subnet_1a_id" {
  value = aws_subnet.public_1a.id
  description = "The public subnet id of the ap-northeast-1a"
}

output "private_subnet_1a_id" {
  value = aws_subnet.private_1a.id
  description = "The private subnet id of the ap-northeast-1a"
}

output "private_subnet_1c_id" {
  value = aws_subnet.private_1c.id
  description = "The private subnet id of the ap-northeast-1c"
}