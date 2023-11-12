terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = "AKIAZPRNVNCDKATBTM7S"
  secret_key = "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"
}

################################################################################
# Network Module
################################################################################

module "network" {
  source               = "./modules/network/"

  env                  = var.env
  name                 = var.name
  
  vpc_cidr             = var.vpc_cidr

  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  availability_zones   = var.availability_zones

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway   = true
  single_nat_gateway   = true

}

################################################################################
# EC2 Module - multiple instances with `for_each`
################################################################################

# locals {
#   multiple_instances = {
#     one = {
#       instance_type     = "t3.micro"
#       availability_zone = element(module.vpc.azs, 0)
#       subnet_id         = element(module.vpc.private_subnets, 0)
#       root_block_device = [
#         {
#           encrypted   = true
#           volume_type = "gp3"
#           throughput  = 200
#           volume_size = 50
#           tags = {
#             Name = "my-root-block"
#           }
#         }
#       ]
#     }
#     two = {
#       instance_type     = "t3.small"
#       availability_zone = element(module.vpc.azs, 1)
#       subnet_id         = element(module.vpc.private_subnets, 1)
#       root_block_device = [
#         {
#           encrypted   = true
#           volume_type = "gp2"
#           volume_size = 50
#         }
#       ]
#     }
#     three = {
#       instance_type     = "t3.medium"
#       availability_zone = element(module.vpc.azs, 2)
#       subnet_id         = element(module.vpc.private_subnets, 2)
#     }
#   }
# }

# module "ec2_multiple" {
#   source = "./modules/instance/"

#   for_each = local.multiple_instances

#   name = "${local.name}-multi-${each.key}"

#   instance_type          = each.value.instance_type
#   availability_zone      = each.value.availability_zone
#   subnet_id              = each.value.subnet_id
#   vpc_security_group_ids = [module.security_group.security_group_id]

#   enable_volume_tags = false
#   root_block_device  = lookup(each.value, "root_block_device", [])

#   tags = local.tags
# }