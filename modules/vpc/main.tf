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

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_block[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    {
    Name = "${local.name}-private-subnet-${split("-",var.azs[count.index])[2]}"
    },
    var.common_tags
  )
}

resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnet_cidr_block[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
    Name = "${local.name}-db-subnet-${split("-",var.azs[count.index])[2]}"
    },
    var.common_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
    Name = "${local.name}-public-rt"
    },
    var.common_tags
  )
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
    Name = "${local.name}-private-rt"
    },
    var.common_tags
  )
}
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
    Name = "${local.name}-db-rt"
    },
    var.common_tags
  )
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "db" {
  count = length(aws_subnet.db)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}

resource "aws_eip" "nat_eip" {
  count = var.enable_nat ? 1 : 0
  domain   = "vpc"
}
resource "aws_nat_gateway" "example" {
  count = var.enable_nat ? 1 : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    {
    Name = "${local.name}-nat"
    },
    var.common_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "public_internet" {
  route_table_id            = aws_route_table.public.id
  gateway_id = aws_internet_gateway.gw.id
  destination_cidr_block   = "0.0.0.0/0"
}

resource "aws_route" "private_internet" {
  route_table_id            = aws_route_table.private.id
  nat_gateway_id  = aws_nat_gateway.example[count.index].id
  destination_cidr_block   = "0.0.0.0/0"
}
resource "aws_route" "private_nat" {
  route_table_id            = aws_route_table.private.id
  nat_gateway_id  = aws_nat_gateway.example[count.index].id
  destination_cidr_block   = "0.0.0.0/0"
}
resource "aws_route" "db_nat" {
  route_table_id            = aws_route_table.db.id
  nat_gateway_id  = aws_nat_gateway.example[count.index].id
  destination_cidr_block   = "0.0.0.0/0"
}
