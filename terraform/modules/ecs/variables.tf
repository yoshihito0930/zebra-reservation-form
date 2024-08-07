variable "studio_name" {
  description = "The name of studio (e.g., studio-zebra)"
  type        = string
}

variable "private_subnet_1a_id" {
  description = "The private subnet id of the ap-northeast-1a"
  type        = string
}

variable "private_subnet_1c_id" {
  description = "The private subnet id of the ap-northeast-1c"
  type        = string
}

variable "security_group_ecs_sg_id" {
  description = "The security groupe of the ECS"
  type        = string
}

variable "repository_url" {
  description = "The repository uri"
  type        = string
}
/*
  variable "rds_instance_arn" {
    description = "The ARN for the RDS instance"
    type        = string
  }

  variable "rds_access_repository_url" {
    description = "The repository_url for the RDS access"
    type        = string
  }
*/