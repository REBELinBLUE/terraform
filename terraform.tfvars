aws_region = "eu-west-2"

# Debian 11 (HVM), SSD Volume Type, 64-bit (x86)
ami = "ami-048df70cfbd1df3a9"

terraform_state_storage = {
  bucket = "rebelinblue-s3-terraform-remote-state"
  dynamodb_table = "terraform-state-lock"
}