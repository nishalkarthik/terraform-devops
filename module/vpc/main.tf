#creating VPC
resource "aws_vpc" "global-vpc" {
  cidr_block = var.vpc-cidr
  tags       = var.vpctag
}

# Creating Public Subnets in VPC
resource "aws_subnet" "public-subnet" {
  count = length(var.public-subentcidr)
  vpc_id                  = aws_vpc.global-vpc.id
  cidr_block              = element(var.public-subentcidr,count.index)
  map_public_ip_on_launch = "true"
  availability_zone       = element(var.AZ-public,count.index)

  tags = {
    Name = "public-subnet-${count.index+1}"
    env = var.env
  }
}
# Creating private Subnets in VPC
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.global-vpc.id
  cidr_block = var.private-subentcidr
  availability_zone = var.AZ-private

  tags = {
    Name = "private-subnet-1"
    env = var.env
  }
}
# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.global-vpc.id
  tags = {
    Name = "vpc-igw"
    env = var.env
  }
}

# Creating Route Tables
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.global-vpc.id
  tags = {
    Name = "public-rt"
    env = var.env
  }
}

#adding igw-route to route-table
resource "aws_route" "add-igw-public-rt" {
  route_table_id = aws_route_table.public-route-table.id
  destination_cidr_block = var.cidr-block
  gateway_id = aws_internet_gateway.igw.id

}


#adding public subnets to rt

resource "aws_route_table_association" "add-public-subnet1-RT" {
  count          = length(aws_subnet.public-subnet.*.id)
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
}

# creating private route table

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.global-vpc.id
  tags = {
    Name = "private-rt"
    env = var.env
  }
}

# create elastic ip for NAT-gateway

resource "aws_eip" "my-ip" {
  domain = "vpc"
}

# creating nat-gateway and attaching eip to it

resource "aws_nat_gateway" "my-nat" {
  #if count needed then use count = 1  and  element(aws_subnet.public-subnet.*.id,count.index)
  subnet_id = aws_subnet.public-subnet[0].id
  allocation_id = aws_eip.my-ip.id
}

# adding NAT-gateway route to private-RT

resource "aws_route" "natgatewayroute-privateRT" {
  route_table_id = aws_route_table.private-route-table.id
  gateway_id = aws_nat_gateway.my-nat.id
  destination_cidr_block = var.cidr-block
}

# adding private-subnet to private-rt
resource "aws_route_table_association" "add-priavte-subnet-to-privateRT" {
  count = length(aws_subnet.private-subnet.*.id)
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = element(aws_subnet.private-subnet.*.id,count.index)
}