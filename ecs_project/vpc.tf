data "aws_availability_zones" "az" {

}

resource "aws_vpc" "product_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "Product VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.product_vpc.cidr_block, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  vpc_id                  = aws_vpc.product_vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.product_vpc.cidr_block, 8, count.index + 3)
  availability_zone = data.aws_availability_zones.az.names[count.index]
  vpc_id            = aws_vpc.product_vpc.id

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.product_vpc.id

  tags = {
    Name = "IGW Public Subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.product_vpc.id
  route {
    cidr_block = var.to_internet
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route Table External"
  }
}

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.product_vpc.id
#   route {
#       cidr_block = var.to_internet
#       gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "Route Table External"
#   }
# }

resource "aws_route_table_association" "public_route_table_association" {
  count          = var.az_count
  route_table_id = element(aws_route_table.public_route_table.*.id, count.index)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
}