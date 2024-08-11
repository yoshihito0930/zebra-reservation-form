variable "studio_name" {
  description = "The name of studio (e.g., studio-zebra)"
  type        = string
}

variable "domain_name" {
  description = "The domain name of studio (e.g., studiozebra-1st-dev.com)"
  type        = string
}

variable "recipient-address" {
  description = "The address which is sent about reservation-form(e.g., example@gmail.com)"
  type        = string
}

variable "admin-user" {
  description = "The user name of administrator (e.g., zebra-admin)"
  type        = string
}

# RDS
variable "db_identifier" {
  description = "The identifier for the RDS database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}