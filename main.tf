resource "aws_instance" "example" {
  count         = 1
  ami           = var.amis[var.aws_region]
  instance_type = "t2.micro"

  tags = {
    Name : format("terraform_test_ec2-%s", count.index)
    Managed_By : local.managed_by
  }
}