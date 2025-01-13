resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

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
