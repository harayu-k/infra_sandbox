# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "main"
#   }
# }

# resource "aws_subnet" "this" {
#   for_each = { for subnet in local.subnets : subnet.name => subnet }
#   vpc_id     = aws_vpc.main.id
#   cidr_block = each.value.cidr
#   availability_zone = each.value.az

#   tags = {
#     Name = each.value.name
#   }
# }

# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "main"
#   }
# }

# resource "aws_route_table" "name" {

# }

# resource "aws_se" "name" {

# }

# resource "aws_security_group" "allow_tls" {
#   vpc_id      = aws_vpc.main.id
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic and all outbound traffic"

#   tags = {
#     Name = "allow_tls"
#   }
# }
