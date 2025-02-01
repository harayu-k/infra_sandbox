resource "aws_ecs_cluster" "backend" {
  name = "backend"
}

resource "aws_ecs_cluster" "frontend" {
  name = "frontend"
}

############################
# backend
############################

resource "aws_ecs_service" "backend" {
  name            = "backend"
  cluster         = aws_ecs_cluster.backend.arn
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 0
  launch_type = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_blue.arn
    container_name   = "backend"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets = [
      aws_subnet.this["private_app_1a"].id,
      aws_subnet.this["private_app_1c"].id,
    ]
    security_groups = [
      aws_security_group.this["backend"].id,
    ]
  }

  lifecycle {
    ignore_changes = [
      load_balancer, # B/G deployのため
    ]
  }
}

resource "aws_ecs_task_definition" "backend" {
  family = "backend"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = "512"
  memory = "1024"
  execution_role_arn = aws_iam_role.backend_ecs_task_execution.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name = "backend"
      image = "992382441056.dkr.ecr.ap-northeast-1.amazonaws.com/backend:initial"
      cpu = 256
      memory            = 1024
      memoryReservation = 512
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [{
        appProtocol   = "http"
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }]
    }
  ])

  lifecycle {
    ignore_changes = [
      container_definitions, # CI/CDなどTerraform外でタスク定義を更新するため
    ]
  }
}

############################
# frontend
############################

resource "aws_ecs_task_definition" "frontend" {
  family = "frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = "512"
  memory = "1024"
  execution_role_arn = aws_iam_role.frontend_ecs_task_execution.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name = "frontend"
      image = "992382441056.dkr.ecr.ap-northeast-1.amazonaws.com/frontend:initial"
      cpu = 256
      memory            = 1024
      memoryReservation = 512
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/frontend"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [{
        appProtocol   = "http"
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }]
    }
  ])

  lifecycle {
    ignore_changes = [
      container_definitions, # CI/CDなどTerraform外でタスク定義を更新するため
    ]
  }
}
