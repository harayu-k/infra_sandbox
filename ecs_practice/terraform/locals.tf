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
    {
      az = "ap-northeast-1a"
      cidr = "10.0.248.0/24"
      name = "private_vpc_endpoint_1a"
    },
    {
      az = "ap-northeast-1c"
      cidr = "10.0.249.0/24"
      name = "private_vpc_endpoint_1c"
    },
  ]

  route_table_names = [
    "ingress",
    "app",
    "db",
  ]

  route_table_associations = [
    {
      route_table = "ingress"
      subnet =  "public_management_1a"
    },
    {
      route_table = "ingress"
      subnet =  "public_management_1c"
    },
    {
      route_table = "ingress"
      subnet =  "public_ingress_1a"
    },
    {
      route_table = "ingress"
      subnet =  "public_ingress_1c"
    },
    {
      route_table = "app"
      subnet =  "private_app_1a"
    },
    {
      route_table = "app"
      subnet =  "private_app_1c"
    },
    {
      route_table = "db"
      subnet =  "private_db_1a"
    },
    {
      route_table = "db"
      subnet =  "private_db_1c"
    },
  ]

  security_groups = [
    "ingress",
    "frontend",
    "backend",
    "internal",
    "database",
    "management",
    "vpc_endpoint"
  ]

  vpc_interface_endpoint = [
    {
      service_name = "ecr_api"
      security_group_ids = [
        aws_security_group.this["vpc_endpoint"].id,
      ]
      subnet_ids = [
        aws_subnet.this["private_vpc_endpoint_1a" ].id,
        aws_subnet.this["private_vpc_endpoint_1c" ].id,
      ]
    },
    {
      service_name = "ecr_dkr"
      security_group_ids = [
        aws_security_group.this["vpc_endpoint"].id,
      ]
      subnet_ids = [
        aws_subnet.this["private_vpc_endpoint_1a" ].id,
        aws_subnet.this["private_vpc_endpoint_1c" ].id,
      ]
    }
  ]
}
