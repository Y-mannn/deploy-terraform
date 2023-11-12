region             = "ap-northeast-2"

env                = "prd"

name               = "devops"

vpc_cidr           = "10.20.0.0/16"

public_subnets     = [
    "10.20.1.0/24",
    "10.20.2.0/24",
]

private_subnets    = [
    "10.20.3.0/24",
    "10.20.4.0/24",
    "10.20.5.0/24",
    "10.20.6.0/24",
    "10.20.7.0/24",
    "10.20.8.0/24",
]

availability_zones = [
    "ap-northeast-2a",
    "ap-northeast-2c",
]