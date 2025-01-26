module "aws" {
  source = "github.com/suzuki-shunsuke/terraform-aws-tfaction?ref=v0.2.4"

  name                               = "AWS"
  repo                               = "harayu-k/infra_sandbox"
  s3_bucket_tfmigrate_history_name   = "my-sandbox-tf-history"
  s3_bucket_terraform_state_name     = "my-sandbox-tf-state"
}
