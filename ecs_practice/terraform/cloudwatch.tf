resource "aws_cloudwatch_log_group" "ecs_backend" {
  name = "/ecs/backend"
  retention_in_days = 3
}
