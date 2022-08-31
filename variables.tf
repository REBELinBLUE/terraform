variable "aws_region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS region"
}

variable "amis" {
  type        = map(string)
  description = "Region specific AWS Machine Images (AMI)"
}

variable "terraform_state_storage" {
  description = "Details of the AWS cloud infrastructure that stores Terraform state"

  type = object({
    bucket         = string
    dynamodb_table = string
  })
}