resource "aws_launch_template" "aws_lt" {
  name          = "LT-ec2-${var.stage}-${var.servicename}"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
  )


  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = merge(tomap({
    Name = "LT-ec2-${var.stage}-${var.servicename}" }),
    var.tags
  )
}

resource "aws_security_group" "ec2_sg" {
  name   = "LT-ec2-sg-${var.stage}-${var.servicename}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [var.openvpn_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(tomap({
    Name = "LT-ec2-sg-${var.stage}-${var.servicename}" }),
    var.tags
  )
}