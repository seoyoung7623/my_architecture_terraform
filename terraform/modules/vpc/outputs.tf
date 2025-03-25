output "aws-vpc-id" {
    value = aws_vpc.aws-vpc.id
}
output "subnet-public-az1" {
    value = aws_subnet.subnet-public-az1 
}

output "subnet-public-az2" {
    value = aws_subnet.subnet-public-az2
}

output "subnet-private-az1" {
  value = aws_subnet.subnet_private_az1
}

output "subnet-private-az2" {
  value = aws_subnet.subnet_private_az2
}