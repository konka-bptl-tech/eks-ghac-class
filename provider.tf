terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
  }
  backend s3 {}
}

provider "aws" {
  region = var.aws_region
}