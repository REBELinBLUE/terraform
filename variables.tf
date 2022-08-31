variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "ami" {
  type        = string
  description = "Region specific AWS Machine Image (AMI)"
}

variable "terraform_state_storage" {
  description = "Details of the AWS cloud infrastructure that stores Terraform state"

  type = object({
    bucket         = string
    dynamodb_table = string
  })
}