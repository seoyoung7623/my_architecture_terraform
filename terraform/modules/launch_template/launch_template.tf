resource "aws_launch_template" "aws-lt" {
  name = "aws-lt-${var.stage}-${var.servicename}"
  image_id = var.ami
  instance_type = var.instance_type

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    EOF
  )
    
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]

  tags = merge(tomap({
    Name = "aws-lt-${var.stage}-${var.servicename}"}),
    var.tags
  ) 
}

resource "aws_security_group" "sg-ec2" {
  name = "ec2-${var.stage}-${var.servicename}"
    vpc_id = var.vpc_id

    ingress {
        from_port = var.port
        to_port = var.port
        protocol = "tcp"
        security_groups = [var.alb_sg_id]
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