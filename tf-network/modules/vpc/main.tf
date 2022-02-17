resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.public_subnet_azs, count.index)
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.public_subnet_name}-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  count  = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_route_table" "public_rt" {
  count = (length(var.public_subnet_cidrs) > 0) ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route" "public_route" {
  count                  = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  route_table_id         = aws_route_table.public_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id
}

resource "aws_route_table_association" "public_subnet_rt_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public_rt.*.id, count.index)
}


resource "aws_eip" "nat_eip" {
  count      = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  count         = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)

  # Associated with first public subnet
  subnet_id  = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-NAT"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.private_subnet_azs, count.index)

  tags = {
    Name = "${var.private_subnet_name}-${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  count = (length(var.public_subnet_cidrs) > 0) ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route" "private_route" {
  count                  = (length(var.private_subnet_cidrs) > 0) ? 1 : 0
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gw[count.index].id
}

resource "aws_route_table_association" "private_subnet_rt_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

