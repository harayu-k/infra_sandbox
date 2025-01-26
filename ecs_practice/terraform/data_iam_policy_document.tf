############################
# assume policy
############################

data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    principals {
      type = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
  }
}

###########################
# policy
############################

data "aws_iam_policy_document" "backend_ecs_task_execution" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    effect = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    effect = "Allow"
    resources = [
      aws_ecr_repository.this["backend"].arn,
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      "${aws_cloudwatch_log_group.ecs_backend.arn}:*",
    ]
  }
}

data "aws_iam_policy_document" "frontend_ecs_task_execution" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    effect = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    effect = "Allow"
    resources = [
      aws_ecr_repository.this["frontend"].arn,
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      "${aws_cloudwatch_log_group.ecs_frontend.arn}:*",
    ]
  }
}
