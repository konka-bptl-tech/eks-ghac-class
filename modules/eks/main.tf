locals {
  name = "${var.environment}-${var.project_name}"
}

resource "aws_eks_cluster" "example" {
  name = "${local.name}-eks-cluster"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids_cluster
    security_group_ids = [aws_security_group.allow_all.id]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs = var.public_access_cidrs
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# resource "aws_launch_template" "foo" {
#   for_each = var.node_groups
#   name     = "${local.name}-eks-node-group-${each.key}"

#   vpc_security_group_ids = [aws_security_group.allow_all.id]

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 20
#       volume_type = "gp3"
#     }
#   }

#   key_name = "siva"


#   tag_specifications {
#     resource_type = "instance"
#     tags = merge(
#       var.common_tags,
#       {
#         Name = "${local.name}-eks-node-group-${each.key}"
#       }
#     )
#   }
# }

# resource "aws_eks_node_group" "example" {
#   for_each        = var.node_groups
#   cluster_name    = aws_eks_cluster.example.name
#   node_group_name = each.key
#   node_role_arn   = aws_iam_role.node_group.arn
#   subnet_ids      = var.private_subnet_ids
#   instance_types  = each.value["instance_types"]
#   capacity_type   = each.value["capacity_type"]

#   scaling_config {
#     desired_size = each.value["desired_size"]
#     max_size     = each.value["max_size"]
#     min_size     = each.value["min_size"]
#   }

#   update_config {
#     max_unavailable = 1
#   }
#   launch_template {
#     id      = aws_launch_template.foo[each.key].id
#     version = "$Latest"
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }
