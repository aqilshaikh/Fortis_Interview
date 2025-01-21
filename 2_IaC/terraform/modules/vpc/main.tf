resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  count     = length(var.private_subnet_cidrs)
  vpc_id    = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "Private Subnet ${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_eip" "main" {
  vpc = true
}
