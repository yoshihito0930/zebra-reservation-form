output "private_subnet_tokyo" {
  value = aws_subnet.private_tokyo.id,
  description = "The private subnet of the Tokyo region"
}

output "private_subnet_osaka" {
  value = aws_subnet.private_osaka.id,
  description = "The private subnet of the Osaka region"
}