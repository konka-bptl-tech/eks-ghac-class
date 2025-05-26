aws_region = "us-east-1"
common_variables = {
  environment = "stage"
  project_name = "ugl"
  common_tags = {
    "Project" = "ugl"
    "Environment" = "stage"
    "ManagedBy" = "Terraform"
  }
}

vpc = {
  vpc_cidr_block = "10.2.0.0/16"
}