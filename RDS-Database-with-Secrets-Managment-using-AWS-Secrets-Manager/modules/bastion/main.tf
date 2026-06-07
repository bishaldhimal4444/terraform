resource "aws_key_pair" "this" {
  key_name   = var.key_pair_name
  public_key = file("${path.root}/modules/bastion/bastion-key.pub")
}

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "this" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = var.public_subnet_id

  vpc_security_group_ids = [
    var.bastion_sg_id
  ]

  key_name = aws_key_pair.this.key_name

  associate_public_ip_address = true

  tags = {
    Name = "rds-project/Bastion-Host"
  }
}

resource "aws_eip" "this" {

  domain = "vpc"

  tags = {
    Name = "rds-project/bastion-eip"
  }
}

resource "aws_eip_association" "this" {

  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this.id
}

