# VPC
resource "aws_vpc" "aws_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(tomap({ # merge 함수를 사용하여 기본 태그와 사용자 정의 태그를 병합
    Name = "aws_vpc-${var.stage}-${var.servicename}" }),
  var.tags)
}

resource "aws_subnet" "subnet_public_az1" {
  vpc_id                  = aws_vpc.aws_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, 0)
  availability_zone       = var.az[0]
  map_public_ip_on_launch = true
  tags = merge(tomap({
    Name = "subnet-public-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

resource "aws_subnet" "subnet_public_az2" {
  vpc_id                  = aws_vpc.aws_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, 1)
  availability_zone       = var.az[1]
  map_public_ip_on_launch = true
  tags = merge(tomap({
    Name = "subnet-public-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

# 프라이빗 서브넷 WEB
resource "aws_subnet" "subnet_service_az1" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 2)
  availability_zone = var.az[0]
  tags = merge(tomap({
    Name = "subnet-service-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

resource "aws_subnet" "subnet_service_az2" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 3)
  availability_zone = var.az[1]
  tags = merge(tomap({
    Name = "subnet-service-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

# 프라이빗 서브넷 WAS
resource "aws_subnet" "subnet_private_az1" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 4)
  availability_zone = var.az[0]
  tags = merge(tomap({
    Name = "subnet-private-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

resource "aws_subnet" "subnet_private_az2" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 5)
  availability_zone = var.az[1]
  tags = merge(tomap({
    Name = "subnet-private-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

# DB 서브넷
resource "aws_subnet" "subnet_db_az1" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 6)
  availability_zone = var.az[0]
  tags = merge(tomap({
    Name = "subnet-db-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

resource "aws_subnet" "subnet_db_az2" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, 7)
  availability_zone = var.az[1]
  tags = merge(tomap({
    Name = "subnet-db-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws_vpc
  ]
}

# 퍼블릭 서브넷과 인터넷 게이트웨이 연결방법
# 요소: 인터넷게이트웨이, 라우트 테이블, 라우트 테이블 연결
# 1.인터넷 게이트웨이 생성
resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws_vpc.id
  tags = merge(tomap({
    Name = "aws-igw-${var.stage}-${var.servicename}" }),
  var.tags)
}

# 2-1.라우트 테이블 생성
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.aws_vpc.id
  tags = merge(tomap({
    Name = "public-${var.stage}-${var.servicename}" }),
  var.tags)
}

# 2-2.IGW 라우트 설정
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
  lifecycle {
    create_before_destroy = true
  }
}

#3.  퍼블릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.subnet_public_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.subnet_public_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway 생성
resource "aws_eip" "eip1" {
  domain = "vpc"
}

resource "aws_eip" "eip2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.subnet_public_az1.id
  depends_on    = [aws_internet_gateway.aws-igw]
  tags = merge(tomap({
    Name = "nat-gateway-az1-${var.stage}-${var.servicename}" }),
  var.tags)
}

resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.subnet_public_az2.id
  depends_on    = [aws_internet_gateway.aws-igw]
  tags = merge(tomap({
    Name = "nat-gateway-az2-${var.stage}-${var.servicename}" }),
  var.tags)

}

resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.aws_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = merge(tomap({
    Name = "private-rt2-${var.stage}-${var.servicename}" }),
  var.tags)
}

resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.aws_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }
  tags = merge(tomap({
    Name = "private-rt2-${var.stage}-${var.servicename}" }),
  var.tags)
}

resource "aws_route_table_association" "private_subnet_rt_assoc1" {
  subnet_id      = aws_subnet.subnet_private_az1.id
  route_table_id = aws_route_table.private_rt1.id
}

resource "aws_route_table_association" "private_subnet_rt_assoc2" {
  subnet_id      = aws_subnet.subnet_private_az2.id
  route_table_id = aws_route_table.private_rt2.id
}

resource "aws_route_table_association" "private_subnet_rt_assoc3" {
  subnet_id      = aws_subnet.subnet_db_az1.id
  route_table_id = aws_route_table.private_rt1.id
}

resource "aws_route_table_association" "private_subnet_rt_assoc4" {
  subnet_id      = aws_subnet.subnet_db_az2.id
  route_table_id = aws_route_table.private_rt2.id
}