data "aws_subnet" "subnet" {
  id = var.subnet_id
}

locals {
  vpc_id = data.aws_subnet.subnet.vpc_id
}

# OpenVPN Server
resource "aws_instance" "openvpn" {
  ami                         = "ami-09a093fa2e3bfca5a" # OpenVPN AMI
  instance_type               = "t2.small"
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.openvpn_sg.id]
  associate_public_ip_address = true

  tags = merge(tomap({
    Name = "OpenVPN-${var.stage}-${var.servicename}" }),
    var.tags
  )
}

resource "aws_security_group" "openvpn_sg" {
  name        = "OpenVPN-sg-${var.stage}-${var.servicename}"
  description = "Security group for OpenVPN Server"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Custom TCP"
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Custom UDP"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(tomap({
    Name = "OpenVPN-sg-${var.stage}-${var.servicename}" }),
    var.tags
  )
}
