resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true # for vpc endpoint
  enable_dns_hostnames = true # for vpc endpoint

  tags = {
    Name = "main"
  }
}

############################
# subnet
############################

resource "aws_subnet" "this" {
  for_each = { for subnet in local.subnets : subnet.name => subnet }
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

############################
# igw
############################

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

############################
# route table
############################

resource "aws_route_table" "this" {
  for_each = toset(local.route_table_names)
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = each.value == "ingress" ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
    }
  }
  tags = {
    Name = each.value
  }
}

resource "aws_route_table_association" "this" {
  for_each = { for a in local.route_table_associations :
                "${a.route_table}_${a.subnet}" => a
              }
  route_table_id = aws_route_table.this["${each.value.route_table}"].id
  subnet_id      = aws_subnet.this["${each.value.subnet}"].id
}

############################
# security group
############################

resource "aws_security_group" "this" {
  for_each = toset(local.security_groups)
  vpc_id      = aws_vpc.main.id
  name        = each.value

  tags = {
    Name = each.value
  }
}

resource "aws_vpc_security_group_ingress_rule" "internal" {
  security_group_id = aws_security_group.this["internal"].id
  ip_protocol = "tcp"
  from_port   = 80
  to_port = 80
  referenced_security_group_id = aws_security_group.this["frontend"].id
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_backend" {
  security_group_id = aws_security_group.this["vpc_endpoint"].id
  referenced_security_group_id = aws_security_group.this["backend"].id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_frontend" {
  security_group_id = aws_security_group.this["vpc_endpoint"].id
  referenced_security_group_id = aws_security_group.this["frontend"].id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "backend" {
  security_group_id = aws_security_group.this["backend"].id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "frontend" {
  security_group_id = aws_security_group.this["frontend"].id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

# resource "aws_vpc_security_group_ingress_rule" "frontend" {
#   security_group_id = aws_security_group.this["frontend"].id
#   referenced_security_group_id = aws_security_group.this["ingress"].id
#   ip_protocol = "-1"
#   cidr_ipv4 = "0.0.0.0/0"
# }

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.this["ingress"].id
  ip_protocol = "tcp"
  from_port = "80"
  to_port = "80"
}

# ############################
# # vpc endpoint
# ############################

resource "aws_vpc_endpoint" "interface" {
  for_each = { for e in local.vpc_interface_endpoint :
    e.service_name => e
  }
  vpc_id = aws_vpc.main.id
  service_name      =  "com.amazonaws.ap-northeast-1.${join(".", split("_",each.value.service_name))}"
  vpc_endpoint_type = "Interface"

  security_group_ids = each.value.security_group_ids
  subnet_ids = each.value.subnet_ids

  private_dns_enabled = true
  tags = {
    Name = each.value.service_name
  }
}

resource "aws_vpc_endpoint" "interface_logs" {
  vpc_id = aws_vpc.main.id
  service_name      =  "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.this["vpc_endpoint"].id,
  ]
  subnet_ids = [
    aws_subnet.this["private_vpc_endpoint_1a" ].id,
    aws_subnet.this["private_vpc_endpoint_1c" ].id,
  ]

  private_dns_enabled = true
  tags = {
    Name = "cw-logs"
  }
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.this["app"].id,
  ]

  tags = {
    Name = "s3_gateway"
  }
}
