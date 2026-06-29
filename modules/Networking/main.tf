#creating vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

#creating subnets
resource "aws_subnet" "publicappsubnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_app_subnet1_id
  availability_zone       = var.availability_zone1_value
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_app_subnet1_name
  }
}
resource "aws_subnet" "publicappsubnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_app_subnet2_id
  availability_zone       = var.availability_zone2_value
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_app_subnet2_name
  }
}
resource "aws_subnet" "privateappsubnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_app_subnet1_id
  availability_zone = var.availability_zone1_value
  tags = {
    Name = var.private_app_subnet1_name
  }
}
resource "aws_subnet" "privateappsubnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_app_subnet2_id
  availability_zone = var.availability_zone2_value
  tags = {
    Name = var.private_app_subnet2_name
  }
}
resource "aws_subnet" "privatedbsubnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_db_subnet1_id
  availability_zone = var.availability_zone1_value
  tags = {
    Name = var.private_db_subnet1_name
  }
}
resource "aws_subnet" "privatedbsubnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_db_subnet2_id
  availability_zone = var.availability_zone2_value
  tags = {
    Name = var.private_db_subnet2_name
  }
}

#creating internet gateway
resource "aws_internet_gateway" "my_int_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.igw_name
  }
}

#creating route tables and associations
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.igw_cidr
    gateway_id = aws_internet_gateway.my_int_gw.id
  }
  tags = {
    Name = var.public_route_table_name
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.publicappsubnet1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_route_table_association1" {
  subnet_id      = aws_subnet.publicappsubnet2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "private_route_table_association2" {
  subnet_id      = aws_subnet.privateappsubnet1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association3" {
  subnet_id      = aws_subnet.privateappsubnet2.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association4" {
  subnet_id      = aws_subnet.privatedbsubnet1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association5" {
  subnet_id      = aws_subnet.privatedbsubnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

