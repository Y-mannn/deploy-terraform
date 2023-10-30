resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "igw" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id

  depends_on = [ aws_route_table.public_route_table ]
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public_subnet.*.id
  route_table_id = aws_route_table.public_route_table.id
}