resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_key" {
  key_name = "terraform"
  public_key = tls_private_key.terraform_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terraform_key.private_key_pem}' > ./terraform.pem
      chmod 400 ./terraform.pem
      echo '${tls_private_key.terraform_key.private_key_pem}' > ./terraform_pub.pem
    EOT
  }
}

resource "aws_vpc" "provisionerVPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-terraform-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = var.public_cidr
  vpc_id                  = aws_vpc.provisionerVPC.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "dev-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.provisionerVPC.id

  tags = {
    Name       = "dev-gw"
    Managed_By = local.managed_by
  }
}

# Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.provisionerVPC.id

  route {
    cidr_block = var.cidr_blocks
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name  = "dev-public-route"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 1
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.id
  depends_on     = [aws_route_table.public_route, aws_subnet.public_subnet]
}

# Security Group
resource "aws_security_group" "dev_terraform_sg_allow_ssh_http" {
  name   = "dev-sg"
  vpc_id = aws_vpc.provisionerVPC.id
}

# Ingress Security Port 22 (Inbound)
resource "aws_security_group_rule" "ssh_ingress_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.dev_terraform_sg_allow_ssh_http.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = [var.cidr_blocks]
}

# Ingress Security Port 80 (Inbound)
resource "aws_security_group_rule" "http_ingress_access" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.dev_terraform_sg_allow_ssh_http.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = [var.cidr_blocks]
}

# All egress Access (Outbound)
resource "aws_security_group_rule" "all_egress_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dev_terraform_sg_allow_ssh_http.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = [var.cidr_blocks]
}

# Instance
resource "aws_instance" "example" {
  ami                    = data.aws_ami.packeramis.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.dev_terraform_sg_allow_ssh_http.id]
  subnet_id              = aws_subnet.public_subnet.id

  provisioner "local-exec" {
    command = "echo Instance Type=${self.instance_type}, Instance ID=${self.id}, Public DNS=${self.public_dns}, AMI ID=${self.ami} >> allinstancedetails"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt update -y",
  #     "sudo apt install -y nginx",
  #     "sudo service nginx start"
  #   ]
  # }

  connection {
    type        = "ssh"
    host        = aws_instance.example.public_ip
    user        = "ubuntu"
    password    = ""
    private_key = file("./terraform.pem")
  }
}