################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count                   = local.create_private_subnets ? local.length_private_subnets : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(concat(var.private_subnets, [""]), count.index) 
  availability_zone       = element(concat(var.availability_zones, [""]), count.index % 2)

  tags = merge(
    { "Name" = "${var.env}-${var.name}-private-subnet" }
  )
}

# There are as many routing tables as the number of NAT gateways
resource "aws_route_table" "private" {
  count                   = local.create_private_subnets ? local.nat_gateway_count : 0

  vpc_id                  = aws_vpc.vpc.id

  tags = merge(
    { "Name" = "${var.env}-${var.name}-private-subnet-rt" }
  )
}

resource "aws_route_table_association" "private" {
  count                   = local.create_private_subnets ? local.length_private_subnets : 0

  subnet_id               = element(aws_subnet.private[*].id, count.index)
  route_table_id          = element(aws_route_table.private[*].id, var.single_nat_gateway ? 0 : count.index % 2)
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat" {
  count                   = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  domain                  = "vpc"

  tags = merge(
    { "Name" = "${var.env}-${var.name}-nat-eip" }
  )

  depends_on              = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  count                   = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id           = element(aws_eip.nat[*].id, var.single_nat_gateway ? 0 : count.index)
  subnet_id               = element(aws_subnet.public[*].id, var.single_nat_gateway ? 0 : count.index)

  tags = merge(
    { "Name" = "${var.env}-${var.name}-nat" }
  )

  depends_on              = [aws_internet_gateway.igw]
}

resource "aws_route" "private" {
  count                   = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id          = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = element(aws_nat_gateway.nat[*].id, count.index)

  timeouts {
    create = "5m"
  }
}