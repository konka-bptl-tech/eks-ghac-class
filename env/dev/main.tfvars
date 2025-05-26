aws_region = "us-east-1"
common_variables = {
  environment = "dev"
  project_name = "ugl"
  common_tags = {
    "Project" = "ugl"
    "Environment" = "dev"
    "ManagedBy" = "Terraform"
  }
}

vpc = {
  vpc_cidr_block = "10.1.0.0/16"
}