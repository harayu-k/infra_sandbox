resource "aws_lb" "internal" {
  name = "internal"
  internal           = true
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  subnets = [
    aws_subnet.this["private_app_1a"].id,
    aws_subnet.this["private_app_1c"].id,
  ]
  security_groups = [
    aws_security_group.this["internal"].id,
  ]
}

resource "aws_lb_target_group" "backend_blue" {
  name        = "backend-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path = "/healthcheck"
    interval = 15
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 2
    matcher = 200
  }
}

resource "aws_lb_target_group" "backend_green" {
  name        = "backend-green"
  port        = 10080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path = "/healthcheck"
    interval = 15
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 2
    matcher = 200
  }
}

resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action, # B/G deployのため
    ]
  }
}

resource "aws_lb" "ingress" {
  name = "ingress"
  internal           = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  subnets = [
    aws_subnet.this["public_ingress_1a"].id,
    aws_subnet.this["public_ingress_1c"].id,
  ]
  security_groups = [
    aws_security_group.this["ingress"].id,
  ]
}
