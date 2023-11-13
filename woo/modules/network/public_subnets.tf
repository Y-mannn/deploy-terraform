################################################################################
# Publiс Subnets
################################################################################

resource "aws_subnet" "public" {
  for_each                = local.create_public_subnets ? var.public_subnets : {}

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = each.value[0]
  availability_zone       = each.value[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    { "Name" = "${var.env}-${var.name}-${each.key}-sb" }
  )
}

resource "aws_route_table" "public" {
  count                   = local.create_public_subnets ? 1 : 0

  vpc_id                  = aws_vpc.vpc[0].id

  tags = merge(
    { "Name" = "${var.name}-${var.name}-public-subnet-rt" }
  )
}

resource "aws_route_table_association" "public" {
  for_each                = local.create_public_subnets ? var.public_subnets : {}


  subnet_id               = aws_subnet.public[each.key].id
  route_table_id          = aws_route_table.public[0].id
}

resource "aws_route" "public" {
  count                   = local.create_public_subnets && var.create_igw ? 1 : 0

  route_table_id          = aws_route_table.public[0].id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw[0].id

  timeouts {
    create = "5m"
  }
}