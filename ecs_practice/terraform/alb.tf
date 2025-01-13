resource "aws_lb" "backend" {
  name = "ecs-backend"
  internal           = true
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  subnets = [
    aws_subnet.this["private_app_1a"].id,
    aws_subnet.this["private_app_1c"].id,
  ]
  security_groups = [
    aws_security_group.this["ingress"].id,
  ]
}
