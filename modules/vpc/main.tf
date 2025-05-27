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
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
    Name = "${local.name}-igw"
    },
    var.common_tags
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_block[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
    Name = "${local.name}-public-subnet-${split("-",var.azs[count.index])[2]}"
    },
    var.common_tags
  )
}