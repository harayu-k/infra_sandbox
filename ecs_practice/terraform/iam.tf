##########################################
# Identity Provider
##########################################
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint,
  ]
}

resource "aws_iam_role_policy_attachment" "terraform_apply_admin" {
  role       = module.aws.aws_iam_role_terraform_apply_name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "terraform_plan_readonly" {
  role       = module.aws.aws_iam_role_terraform_plan_name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "tfmigrate_plan_readonly" {
  role       = module.aws.aws_iam_role_tfmigrate_plan_name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "tfmigrate_apply_readonly" {
  role       = module.aws.aws_iam_role_tfmigrate_apply_name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

############################
# iam policy
############################

data "aws_iam_policy" "ecs_codedeploy" {
  name = "AWSCodeDeployRoleForECS"
}

resource "aws_iam_policy" "backend_ecs_task_execution" {
  name = "backend-AWSECSTaskExeccutionRole"
  policy = data.aws_iam_policy_document.backend_ecs_task_execution.json
}

resource "aws_iam_policy" "frontend_ecs_task_execution" {
  name = "frontend-AWSECSTaskExeccutionRole"
  policy = data.aws_iam_policy_document.frontend_ecs_task_execution.json
}

############################
# iam role
############################

resource "aws_iam_role" "ecs_codedeploy" {
  name = "ECSCodeDeploy"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

resource "aws_iam_policy_attachment" "ecs_codedeploy" {
  name = "ECSCodeDeploy"
  roles = [
    aws_iam_role.ecs_codedeploy.name,
  ]
  policy_arn = data.aws_iam_policy.ecs_codedeploy.arn
}

resource "aws_iam_role" "backend_ecs_task_execution" {
  name = "backend-ECSTaskExecution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_policy_attachment" "backend_ecs_task_execution" {
  name = "backend-ECSTaskExecution"
  roles = [
    aws_iam_role.backend_ecs_task_execution.name,
  ]
  policy_arn = aws_iam_policy.backend_ecs_task_execution.arn
}

resource "aws_iam_role" "frontend_ecs_task_execution" {
  name = "frontend-ECSTaskExecution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_policy_attachment" "frontend_ecs_task_execution" {
  name = "frontend-ECSTaskExecution"
  roles = [
    aws_iam_role.frontend_ecs_task_execution.name,
  ]
  policy_arn = aws_iam_policy.frontend_ecs_task_execution.arn
}
