module "aws" {
  source = "github.com/suzuki-shunsuke/terraform-aws-tfaction?ref=v0.2.4"

  name                               = "AWS"
  repo                               = "harayu-k/infra_sandbox"
  s3_bucket_tfmigrate_history_name   = aws_s3_bucket.tf_history.bucket
  s3_bucket_terraform_state_name     = aws_s3_bucket.tf_state.bucket
}

# Attach Policies

# resource "aws_iam_role_policy_attachment" "terraform_apply_admin" {
#   role       = module.aws.aws_iam_role_terraform_apply_name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

# resource "aws_iam_role_policy_attachment" "terraform_plan_readonly" {
#   role       = module.aws.aws_iam_role_terraform_plan_name
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }

# resource "aws_iam_role_policy_attachment" "tfmigrate_plan_readonly" {
#   role       = module.aws.aws_iam_role_tfmigrate_plan_name
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }

# resource "aws_iam_role_policy_attachment" "tfmigrate_apply_readonly" {
#   role       = module.aws.aws_iam_role_tfmigrate_apply_name
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }
