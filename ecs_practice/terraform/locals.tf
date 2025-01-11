locals {
  subnets = [
    {
      az = "ap-northeast-1a"
      cidr = "10.0.0.0/24"
      name = "public_ingress_1a"
    },
    {
      az = "ap-northeast-1c"
      cidr = "10.0.1.0/24"
      name = "public_ingress_1c"
    },
    {
      az = "ap-northeast-1a"
      cidr = "10.0.8.0/24"
      name = "private_app_1a"
    },
    {
      az = "ap-northeast-1c"
      cidr = "10.0.9.0/24"
      name = "private_app_1c"
    },
    {
      az = "ap-northeast-1a"
      cidr = "10.0.16.0/24"
      name = "private_db_1a"
    },
    {
      az = "ap-northeast-1c"
      cidr = "10.0.17.0/24"
      name = "private_db_1c"
    },
    {
      az = "ap-northeast-1a"
      cidr = "10.0.240.0/24"
      name = "public_management_1a"
    },
    {
      az = "ap-northeast-1c"
      cidr = "10.0.241.0/24"
      name = "public_management_1c"
    },
  ]
}
