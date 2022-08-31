data "aws_ami" "packeramis" {
  owners = ["338122837542"]
  most_recent = true

  filter {
    name = "name"
    values = ["packer-cf*"]
  }
}

data "aws_availability_zones" "available" {}