locals {
  name = "${var.environment}-${var.project_name}"
}
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(
    {
    Name = "${local.name}-vpc"
    },
    var.common_tags
  )
}
