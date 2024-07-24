variable "port_forwarder_repository_url" {
  description = "The repository uri of the port forwarder"
  type        = string
}

variable "aurora_endpoint" {
  description = "The endpoint of Aurora"
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

variable "fargate_sg_id" {
  description = "The security groupe id of the Fargate"
  type        = string
}

variable "studio_name" {
  description = "The name of studio (e.g., studio-zebra)"
  type        = string
}