resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)

  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "private subnet"
  }
}

resource "aws_eip" "eip" {
  domain   = "vpc"

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip
  subnet_id     = aws_subnet.public_subnet.*.id

  depends_on = [aws_eip.aws_eip.eip ]

  tags = {
    Name = "nat"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "nat" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id

  depends_on = [ aws_route_table.private_route_table ]
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.private_subnet.*.id
  route_table_id = aws_route_table.private_route_table.id
}