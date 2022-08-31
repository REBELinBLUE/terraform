data "aws_ami" "packeramis" {
  owners = ["338122837542"]
  most_recent = true

  filter {
    name = "name"
    values = ["packer-cf*"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.packeramis.id
  #ami           = var.ami
  instance_type = "t2.micro"

  tags = {
    Managed_By : local.managed_by
  }

  provisioner "local-exec" {
    command = "echo Instance Type=${self.instance_type}, Instance ID=${self.id}, Public DNS=${self.public_dns}, AMI ID=${self.ami} >> allinstancedetails.tmp"
  }
}

