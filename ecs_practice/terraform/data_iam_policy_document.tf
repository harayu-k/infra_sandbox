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
