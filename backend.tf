terraform {
  backend "s3" {
    bucket         = "rebelinblue-s3-terraform-remote-state" # FIXME: How to make this a variable?
    key            = "terraform.tfstate" # FIXME: How to make this a variable?
    encrypt        = true
    dynamodb_table = "terraform-state-lock" # FIXME: How to make this a variable?
  }
}
