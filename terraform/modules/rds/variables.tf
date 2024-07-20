variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "security_group_id" {
  description = "The security group ID for the RDS instance"
  type        = string
}

variable "private_subnet_tokyo" {
  description = "The private subnet of the Tokyo region"
  type        = string
}

variable "private_subnet_osaka" {
  description = "The private subnet of the Osaka region"
  type        = string
}

variable "studio_name" {
  description = "The name of the studio"
  type        = string
}
