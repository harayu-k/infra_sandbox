resource "aws_ecr_repository" "frontend" {
  name = "frontend"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "backend" {
  name = "backend"
  image_tag_mutability = "IMMUTABLE"
}
