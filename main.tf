module "eks_vpc" {
  source = "./modules/vpc"
  environment   = var.common_variables["environment"]
  project_name  = var.common_variables["project_name"]
  common_tags = var.common_variables["common_tags"]
  vpc_cidr_block = var.vpc["vpc_cidr_block"]
  azs = var.vpc["azs"]
  public_subnet_cidr_block = var.vpc["public_subnet_cidr_block"]
  private_subnet_cidr_block = var.vpc["private_subnet_cidr_block"]
  db_subnet_cidr_block = var.vpc["db_subnet_cidr_block"]
  enable_nat = var.vpc["enable_nat"]
}

module "eks"{
  depends_on = [ module.eks_vpc ]
  source = "./modules/eks"
  environment = var.common_variables["environment"]
  project_name = var.common_variables["project_name"]
  common_tags = var.common_variables["common_tags"]
  vpc_id = module.eks_vpc.vpc_id
  subnet_ids_cluster = module.eks_vpc.private_subnet_ids

  cluster_version = var.eks["cluster_version"]
  endpoint_private_access = var.eks["endpoint_private_access"]
  endpoint_public_access = var.eks["endpoint_public_access"]
  public_access_cidrs = var.eks["public_access_cidrs"]
  bootstrap_cluster_creator_admin_permissions = var.eks["bootstrap_cluster_creator_admin_permissions"]
  node_groups = var.eks["node_groups"]
  addons = var.eks["addons"]
}

module "admin_user" {
  depends_on                     = [module.eks]
  source                         = "./modules/ec2"
  environment                    = var.common_variables["environment"]
  project_name                   = var.common_variables["project_name"]
  common_tags                    = var.common_variables["common_tags"]
  ami                            = data.aws_ami.amazon_linux.id
  instance_type                  = var.siva_instance["instance_type"]
  key_name                       = var.siva_instance["key_name"]
  security_groups                = [module.eks_vpc.sg_id]
  monitoring                     = var.siva_instance["monitoring"]
  subnet_id                      = module.eks_vpc.public_subnet_ids[0]
  user_data                      = var.siva_instance["user_data"]
  use_null_resource_for_userdata = var.siva_instance["use_null_resource_for_userdata"]
  remote_exec_user               = var.siva_instance["remote_exec_user"]
  private_key                    = data.aws_ssm_parameter.ec2_key.value
  iam_instance_profile           = var.siva_instance["iam_instance_profile"]
}