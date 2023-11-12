locals {
  length_public_subnets   = length(var.public_subnets)
  length_private_subnets  = length(var.private_subnets)
  max_subnet_length       = max(local.length_private_subnets, local.length_public_subnets)
  
  create_private_subnets  = var.create_vpc && local.length_private_subnets > 0
  create_public_subnets   = var.create_vpc && local.length_public_subnets > 0

  nat_gateway_count       = var.single_nat_gateway ? 1 : length(var.availability_zones)
}