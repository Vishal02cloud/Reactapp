# Define provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# VPC 1
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc1"
  }
}

# VPC 2
resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc2"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "vpc1_to_vpc2" {
  vpc_id        = aws_vpc.vpc1.id
  peer_vpc_id    = aws_vpc.vpc2.id
  auto_accept    = true

  tags = {
    Name = "vpc1-to-vpc2"
  }
}

# Update VPC 1 route table
resource "aws_route_table" "vpc1_rt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
  }

  tags = {
    Name = "vpc1-route-table"
  }
}

# Associate route table with VPC 1's subnet
resource "aws_route_table_association" "vpc1_subnet_association" {
  subnet_id      = aws_subnet.vpc1_subnet.id
  route_table_id = aws_route_table.vpc1_rt.id
}

# Update VPC 2 route table
resource "aws_route_table" "vpc2_rt" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
  }

  tags = {
    Name = "vpc2-route-table"
  }
}

# Associate route table with VPC 2's subnet
resource "aws_route_table_association" "vpc2_subnet_association" {
  subnet_id      = aws_subnet.vpc2_subnet.id
  route_table_id = aws_route_table.vpc2_rt.id
}

# Define subnets in VPC 1
resource "aws_subnet" "vpc1_subnet" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "vpc1-subnet"
  }
}

# Define subnets in VPC 2
resource "aws_subnet" "vpc2_subnet" {
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "vpc2-subnet"
  }
}
