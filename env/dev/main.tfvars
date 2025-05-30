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
  enable_nat = true
}

eks = {
  cluster_version = "1.31"
  endpoint_private_access = true
  endpoint_public_access = true
  public_access_cidrs = ["0.0.0.0/0"]
  bootstrap_cluster_creator_admin_permissions = true
  node_groups = {
    mini = {
      instance_types = ["t3.medium"]
      capacity_type = "ON_DEMAND"
      desired_size = 2
      max_size = 3
      min_size = 1
      key_name = "siva"
    }
  }
}

siva_instance = { 
  instance_type  = "t3.micro"
  key_name  = "siva"
  monitoring  = false
  use_null_resource_for_userdata  = true
  remote_exec_user = "ec2-user"
  user_data  = <<-EOF
    #!/bin/bash
    sudo dnf update -y
    sudo dnf install git tmux -y
    ARCH=amd64
    PLATFORM=$(uname -s)_$ARCH
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.7/2025-04-17/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
    curl -sS https://webinstall.dev/k9s | bash
    aws eks update-kubeconfig --name dev-ugl-eks-cluster --region us-east-1
    echo "alias k=kubectl" >> /home/ec2-user/.bashrc
    source /home/ec2-user/.bashrc
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    EOF
  iam_instance_profile = "class-demo-role"
}


