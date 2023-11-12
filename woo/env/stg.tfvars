region             = "ap-northeast-2"

env                = "stg"

name               = "devops"

vpc_cidr           = "10.10.0.0/16"

public_subnets     = [
    "10.10.1.0/24",
    "10.10.2.0/24",
]

private_subnets    = [
    "10.10.3.0/24",
    "10.10.4.0/24",
    "10.10.5.0/24",
    "10.10.6.0/24",
    "10.10.7.0/24",
    "10.10.8.0/24",
]

availability_zones = [
    "ap-northeast-2a",
    "ap-northeast-2c",
]
