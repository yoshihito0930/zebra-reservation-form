variable "db_identifier" {
  description = "The identifier for the RDS database"
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

variable "security_group_aurora_mysql_id" {
  description = "The security group ID for the aurora instance"
  type        = string
}

variable "private_subnet_1a_id" {
  description = "The private subnet id of the private_subnet_1a"
  type        = string
}

variable "private_subnet_1c_id" {
  description = "The private subnet id of the private_subnet_1c"
  type        = string
}

variable "studio_name" {
  description = "The name of the studio"
  type        = string
}
