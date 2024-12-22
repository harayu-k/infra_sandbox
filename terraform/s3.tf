resource "aws_s3_bucket" "tf_state" {
  bucket = "my-sandbox-tf-state"
}

resource "aws_s3_bucket" "tf_history" {
  bucket = "my-sandbox-tf-history"
}
