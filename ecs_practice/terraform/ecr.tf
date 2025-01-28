locals {
  aws_ecr_repository_names = [ "frontend", "backend", "fluent-bit" ]
}
resource "aws_ecr_repository" "this" {
  for_each = toset(local.aws_ecr_repository_names)
  name = each.value
  image_tag_mutability = "IMMUTABLE"
  force_delete = true
}
