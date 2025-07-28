resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MyTerraformVPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "MyTerraformSubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MyIGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

resource "aws_instance" "example" {
  ami           = "ami-0b6ab5dd5da28b19a"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "MyTerraformInstance"
  }
}
