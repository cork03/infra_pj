resource "aws_vpc" "vpc" {
  cidr_block                       = "192.170.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

####################################
# public subnet for alb
####################################
resource "aws_subnet" "public_alb_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.170.3.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_alb_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.170.4.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_alb" {
  vpc_id = aws_vpc.vpc.id
}

# route tableの1レコード
resource "aws_route" "public_alb" {
  route_table_id         = aws_route_table.public_alb.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# subnetにroute tableを紐づける
resource "aws_route_table_association" "public_alb_1a" {
  subnet_id      = aws_subnet.public_alb_subnet_1a.id
  route_table_id = aws_route_table.public_alb.id
}

resource "aws_route_table_association" "public_alb_1c" {
  subnet_id      = aws_subnet.public_alb_subnet_1c.id
  route_table_id = aws_route_table.public_alb.id
}
