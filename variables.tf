variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "cidr_blocks" {
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  default = "10.0.1.0/24"
}

variable "public_cidr" {
  default = "10.0.1.0/28"
}

variable "private_cidr" {
  default = "10.0.1.16/28"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "terraform_state_storage" {
  description = "Details of the AWS cloud infrastructure that stores Terraform state"

  type = object({
    bucket         = string
    dynamodb_table = string
  })
}
