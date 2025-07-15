resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MyTerraformVPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "MyTerraformSubnet"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0b6ab5dd5da28b19a" # Example Amazon Linux 2 AMI for eu-west-2
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "MyTerraformInstance"
  }
}
