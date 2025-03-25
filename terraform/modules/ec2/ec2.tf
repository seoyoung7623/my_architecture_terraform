data "aws_subnet" "subnet" {
  id = var.subnet_id
}

locals {
    vpc_id = data.aws_subnet.subnet.vpc_id
}

# 퍼블릭 Instance 생성
resource "aws_instance" "ec2" {
  ami           = var.ami
  associate_public_ip_address = true
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]
  tags = merge(tomap({
    Name = "ec2-${var.stage}-${var.servicename}"}),
    var.tags
  )
}

# 보안그룹 이름은 sg-로 시작하는것 금지!
resource "aws_security_group" "sg-ec2" {
    name = "ec2-${var.stage}-${var.servicename}"
    vpc_id = local.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.ssh_allow_ingress_list
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(tomap({
        Name = "sg-ec2-${var.stage}-${var.servicename}"}),
        var.tags
    )
}