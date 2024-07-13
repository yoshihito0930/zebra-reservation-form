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

variable "subnet_ids" {
  description = "A list of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "studio_name" {
  description = "The name of the studio"
  type        = string
}