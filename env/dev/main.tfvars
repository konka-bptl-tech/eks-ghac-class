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
  azs = ["us-east-1a", "us-east-1b"]
  public_subnet_cidr_block = ["10.1.1.0/24","10.1.2.0/24"]
  private_subnet_cidr_block = ["10.1.11.0/24","10.1.12.0/24"]
  db_subnet_cidr_block = ["10.1.21.0/24","10.1.22.0/24"]
}
