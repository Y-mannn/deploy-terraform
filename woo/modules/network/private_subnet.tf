################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  for_each                = local.create_private_subnets ? var.private_subnets : {}

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = each.value[0]
  availability_zone       = each.value[1]

  tags = merge(
    { "Name" = "${var.env}-${var.name}-${each.key}-sb" }
  )
}

# There are as many routing tables as the number of NAT gateways
resource "aws_route_table" "private" {
  for_each                = local.create_private_subnets ? local.nat_gateway_count : {}

  vpc_id                  = aws_vpc.vpc[0].id

  tags = merge(
    { "Name" = "${var.env}-${var.name}-private-subnet-rt" }
  )
}

resource "aws_route_table_association" "private" {
  for_each                = local.create_private_subnets ? var.private_subnets : {}

  subnet_id               = aws_subnet.private[each.key].id
  route_table_id          = var.single_nat_gateway ? aws_route_table.private[local.nat_gateway_count[0]].id : aws_route_table.private[each.value[1]].id
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat" {
  for_each                = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : {}

  domain                  = "vpc"

  tags = merge(
    { "Name" = "${var.env}-${var.name}-nat-eip" }
  )

  depends_on              = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  for_each                = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : {}

  allocation_id           = var.single_nat_gateway ? aws_eip.nat[local.nat_gateway_count[0]].id : aws_eip.nat[each.value[1]].id
  subnet_id               = var.single_nat_gateway ? aws_subnet.public[*].id : aws_subnet.public[*].id
  # subnet_id               = element(aws_subnet.public[*].id, var.single_nat_gateway ? 0 : count.index)

  tags = merge(
    { "Name" = "${var.env}-${var.name}-nat" }
  )

  depends_on              = [aws_internet_gateway.igw]
}

resource "aws_route" "private" {
  for_each                = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : {}

  route_table_id          = aws_route_table.private[each.key].id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.nat[each.key].id

  timeouts {
    create = "5m"
  }
}