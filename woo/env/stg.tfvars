region             = "ap-northeast-2"

env                = "stg"

name               = "devops"

vpc_cidr           = "10.10.0.0/16"

public_subnets     = {
    "pub01" = ["10.10.1.0/24", "ap-northeast-2a"]
    "pub02" = ["10.10.2.0/24", "ap-northeast-2c"]
}

private_subnets    = {
    "web01" = ["10.10.3.0/24", "ap-northeast-2a"]
    "web02" = ["10.10.4.0/24", "ap-northeast-2c"]
    "was01" = ["10.10.5.0/24", "ap-northeast-2a"]
    "was02" = ["10.10.6.0/24", "ap-northeast-2c"]
    "db01"  = ["10.10.7.0/24", "ap-northeast-2a"]
    "db02"  = ["10.10.8.0/24", "ap-northeast-2c"]
}

availability_zones = {
    "az1"   = "ap-northeast-2a",
    "az2"   = "ap-northeast-2c",
}