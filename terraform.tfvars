aws_region = "eu-west-2"

# Ubuntu Server 22.04 LTS (HVM), SSD Volume Type, 64-bit (x86)
ami = "ami-0fb391cce7a602d1f"

terraform_state_storage = {
  bucket = "rebelinblue-s3-terraform-remote-state"
  dynamodb_table = "terraform-state-lock"
}