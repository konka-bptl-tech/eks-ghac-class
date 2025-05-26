module "eks_vpc" {
  source = "./modules/vpc"
  environment   = var.common_variables["environment"]
  project_name  = var.common_variables["project_name"]
  common_tags = var.common_variables["common_tags"]
  vpc_cidr_block = var.vpc["vpc_cidr_block"]
}