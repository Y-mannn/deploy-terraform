terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc_subnet"

  vpc_cidr = var.vpc_cidr
  
  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs

  availability_zones = var.availability_zones
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
} 

output "nat_ip" {
  value = module.vpc.nat_ip
}