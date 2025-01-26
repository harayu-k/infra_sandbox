resource "aws_cloudwatch_log_group" "ecs_backend" {
  name = "/ecs/backend"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "ecs_frontend" {
  name = "/ecs/frontend"
  retention_in_days = 3
}
