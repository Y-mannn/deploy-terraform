region             = "ap-northeast-2"

env                = "dev"

name               = "devops"

vpc_cidr           = "10.0.0.0/16"

public_subnets     = {
    "pub"  = ["10.0.1.0/24",, "ap-northeast-2a"]
}

private_subnets    = {
    "web"  = ["10.0.2.0/24", "ap-northeast-2a"]
    "was"  = ["10.0.3.0/24", "ap-northeast-2a"]
    "db"   = ["10.0.4.0/24", "ap-northeast-2a"]
}

availability_zones = [
    "az"   ="ap-northeast-2a",
]