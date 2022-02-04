# create vpc and subnet for your cluster

resource "aws_vpc" "project10_vpc_cluster" {
  cidr_block       = var.cidr_block[0]
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    Name = "project10_vpc_cluster"
  }
}

# PUBLIC SUBNET1

resource "aws_subnet" "project10-pubsubnet1" {
  vpc_id     = aws_vpc.project10_vpc_cluster.id
  cidr_block = var.cidr_block[1]
  map_public_ip_on_launch = true
  availability_zone = "eu-west-2a"


  tags = {
    Name = "project10-pubsubnet1"
  }
}

# PUBLIC SUBNET2

resource "aws_subnet" "project10-pubsubnet2" {
  vpc_id     = aws_vpc.project10_vpc_cluster.id
  cidr_block = var.cidr_block[2]
  map_public_ip_on_launch = true
  availability_zone = "eu-west-2b"


  tags = {
    Name = "project10-pubsubnet2"
  }
}

# PRIVATE SUBNET1

resource "aws_subnet" "project10-private_subnet1" {
  vpc_id     = aws_vpc.project10_vpc_cluster.id
  cidr_block = var.cidr_block[3]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2c"


  tags = {
    Name = "project10_private_subnet1"
  }
}

# PRIVATE SUBNET2

resource "aws_subnet" "project10-private_subnet2" {
  vpc_id     = aws_vpc.project10_vpc_cluster.id
  cidr_block = var.cidr_block[4]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2a"


  tags = {
    Name = "project10_private_subnet2"
  }
}

# PUBLIC ROUTE TABLE

resource "aws_route_table" "project10_public_route_table" {
  vpc_id = aws_vpc.project10_vpc_cluster.id

  tags = {
    Name = "project10_route_table"
  }
}

# PRIVATE ROUTE TABLE

resource "aws_route_table" "project10_private_route_table" {
  vpc_id = aws_vpc.project10_vpc_cluster.id

  tags = {
    Name = "project10_route_table"
  }
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "project10-igw" {
  vpc_id = aws_vpc.project10_vpc_cluster.id

  tags = {
    Name = "PROJECT10-igw"
  }
}

# IGW ASSOCIATION WITH ROUTE TABLE

resource "aws_route" "Association_public-RT" {
  route_table_id            = aws_route_table.project10_public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.project10-igw.id
}

# ASSOCIATE PUBLIC SUBNET1 TO PUBLIC ROUTE

resource "aws_route_table_association" "project10-PUBSUB1-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project10-pubsubnet1.id
  route_table_id = aws_route_table.project10_public_route_table.id
}

resource "aws_route_table_association" "project10-PUBSUB2-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project10-pubsubnet2.id
  route_table_id = aws_route_table.project10_public_route_table.id
}

resource "aws_route_table_association" "project10-PRIVSUB1-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project10-private_subnet1.id
  route_table_id = aws_route_table.project10_private_route_table.id
}

resource "aws_route_table_association" "project10-PRIVSUB2-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project10-private_subnet2.id
  route_table_id = aws_route_table.project10_private_route_table.id
}

# security group for instance(EC2) and ECS cluster


# SECURITY GROUP FOR VPC
# terraform aws create security GROUP

resource "aws_security_group" "project10-vpc-security-group" {
  name        = "project10-vpc-security-group"
  description = "Allow ssh and HTTP access or port 80 and 22 and outbound traffic to project10_vpc_cluster"
  vpc_id      = aws_vpc.project10_vpc_cluster.id


  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project10-vpc-security-group"
  }
}
