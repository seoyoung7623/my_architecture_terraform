# VPC
resource "aws_vpc" "aws-vpc" {
  cidr_block           = var.vpc_ip_range
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(tomap({ # merge 함수를 사용하여 기본 태그와 사용자 정의 태그를 병합
    Name = "aws-vpc-${var.stage}-${var.servicename}" }),
  var.tags)
}

resource "aws_subnet" "subnet-public-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = cidrsubnet(var.vpc_ip_range, 3, 0)
  availability_zone       = var.az[0]
  map_public_ip_on_launch = true
  tags = merge(tomap({
    Name = "subnet-public-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

resource "aws_subnet" "subnet-public-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = cidrsubnet(var.vpc_ip_range, 3, 1)
  availability_zone       = var.az[1]
  map_public_ip_on_launch = true
  tags = merge(tomap({
    Name = "subnet-public-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

# 프라이빗 서브넷 WEB
resource "aws_subnet" "subnet-service-az1" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = cidrsubnet(var.vpc_ip_range, 3, 2)
  availability_zone = var.az[0]
  tags = merge(tomap({
    Name = "subnet-service-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

resource "aws_subnet" "subnet-service-az2" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = cidrsubnet(var.vpc_ip_range, 3, 3)
  availability_zone = var.az[1]
  tags = merge(tomap({
    Name = "subnet-service-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

# 프라이빗 서브넷 WAS
resource "aws_subnet" "subnet_private_az1" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = cidrsubnet(var.vpc_ip_range, 3, 4)
  availability_zone = var.az[0]
  tags = merge(tomap({
    Name = "subnet-private-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

resource "aws_subnet" "subnet_private_az2" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = cidrsubnet(var.vpc_ip_range, 3, 5)
  availability_zone = var.az[1]
  tags = merge(tomap({
    Name = "subnet-private-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

# DB 서브넷
resource "aws_subnet" "subnet_db_az1" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = cidrsubnet(var.vpc_ip_range, 3, 6)
  availability_zone = var.az[0]
  tags = merge(tomap({
    Name = "subnet-db-az1-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

resource "aws_subnet" "subnet_db_az2" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = cidrsubnet(var.vpc_ip_range, 3, 7)
  availability_zone = var.az[1]
  tags = merge(tomap({
    Name = "subnet-db-az2-${var.stage}-${var.servicename}" }),
  var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

# 퍼블릭 서브넷과 인터넷 게이트웨이 연결방법
# 요소: 인터넷게이트웨이, 라우트 테이블, 라우트 테이블 연결
# 1.인터넷 게이트웨이 생성
resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
    Name = "aws-igw-${var.stage}-${var.servicename}" }),
  var.tags)
}

# 2-1.라우트 테이블 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
    Name = "public-${var.stage}-${var.servicename}" }),
  var.tags)
}

# 2-2.IGW 라우트 설정
resource "aws_route" "public-internet-gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
  lifecycle {
    create_before_destroy = true
  }
}

#3.  퍼블릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "public-az1" {
  subnet_id      = aws_subnet.subnet-public-az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-az2" {
  subnet_id      = aws_subnet.subnet-public-az2.id
  route_table_id = aws_route_table.public.id
}

