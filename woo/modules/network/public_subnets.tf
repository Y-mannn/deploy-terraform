################################################################################
# Publiс Subnets
################################################################################

resource "aws_subnet" "public" {
  count                   = local.create_public_subnets ? local.length_public_subnets : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = element(concat(var.availability_zones, [""]), count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    { "Name" = "${var.env}-${var.name}-public-subnet" }
  )
}

resource "aws_route_table" "public" {
  count                   = local.create_public_subnets ? 1 : 0

  vpc_id                  = aws_vpc.vpc.id

  tags = merge(
    { "Name" = "${var.name}-${var.name}-public-subnet-rt" }
  )
}

resource "aws_route_table_association" "public" {
  count                   = local.create_public_subnets ? local.length_public_subnets : 0

  subnet_id               = element(aws_subnet.public[*].id, count.index)
  route_table_id          = aws_route_table.public[0].id
}

resource "aws_route" "public" {
  count                   = local.create_public_subnets && var.create_igw ? 1 : 0

  route_table_id          = aws_route_table.public[0].id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}