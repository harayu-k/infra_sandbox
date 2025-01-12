terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket = "my-sandbox-tf-state"
    key = "terraform.tfstate"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Managed = "Terraform"
    }
  }
}
