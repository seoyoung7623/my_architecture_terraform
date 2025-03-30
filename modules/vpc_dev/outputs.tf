output "aws_vpc" {
  value = aws_vpc.aws_vpc
}
output "subnet_public_az1" {
  value = aws_subnet.subnet_public_az1
}

output "subnet_public_az2" {
  value = aws_subnet.subnet_public_az2
}

output "subnet_private_az1" {
  value = aws_subnet.subnet_private_az1
}

output "subnet_private_az2" {
  value = aws_subnet.subnet_private_az2
}