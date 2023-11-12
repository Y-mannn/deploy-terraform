################################################################################
# VPC
################################################################################

resource "aws_vpc" "vpc" {
  count                 = var.create_vpc ? 1 : 0

  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = var.enable_dns_hostnames
  enable_dns_support    = var.enable_dns_support

  tags = merge(
    { "Name" = "${var.env}-${var.name}-vpc" }
  )
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "igw" {
  count                 = var.create_igw && local.create_public_subnets ? 1 : 0

  vpc_id                = aws_vpc.vpc[0].id

  tags = merge(
    { "Name" = "${var.env}-${var.name}-igw" }
  )
}