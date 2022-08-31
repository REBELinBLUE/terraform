aws_region = "eu-west-2"

terraform_state_storage = {
  bucket         = "rebelinblue-s3-terraform-remote-state"
  dynamodb_table = "terraform-state-lock"
}