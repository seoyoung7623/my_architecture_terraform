resource "aws_launch_template" "aws_lt" {
  name          = "LT-ec2-${var.stage}-${var.servicename}"
  image_id      = var.ami
  instance_type = var.instance_type

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2 php php-mysql mysql-server mysql-client unzip wget

    cd /var/www/html

    # 기존 index.html 삭제 (Apache 기본 페이지 제거)
    rm -f index.html

    wget https://wordpress.org/latest.zip
    unzip latest.zip
    cp -r wordpress/* .
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

    systemctl restart apache2
    systemctl enable apache2

    systemctl start mysql
    systemctl enable mysql

    mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
    mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY '123412340';"
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
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