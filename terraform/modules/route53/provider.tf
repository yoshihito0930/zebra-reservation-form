terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.45.0"
    }
  }
}

# ACM用に個別にRegion指定
provider "aws" {
  region  = "us-east-1"
  alias   = "acm_provider"
}