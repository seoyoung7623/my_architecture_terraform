## SSL/TLS 인증서 ARN
data "aws_acm_certificate" "certificate" {
    domain = "seoyoungstudy.shop"
    statuses = ["ISSUED"]
    most_recent = true
}


# ALB 생성
resource "aws_alb" "alb" {
    name = "aws-alb-${var.stage}-${var.servicename}"
    internal = var.internal
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg-alb.id]
    subnets = var.subnet_ids

    enable_deletion_protection = false # 삭제 보호 기능 활성화

    idle_timeout = var.idle_timeout

    # # ALB 접근 로그 S3에 저장
    # access_logs {
    #     bucket = var.aws_s3_lb_logs_name
    #     prefix = "aws-alb-${var.stage}-${var.servicename}" # 파일의 접두사
    #     enabled = true # 접근 로그 기능 활성화
    # }

    tags = merge(tomap({
        Name = "aws-alb-${var.stage}-${var.servicename}"}),
        var.tags
    )
}

# ALB Listener 생성
resource "aws_alb_listener" "alb_listener-80" {
    load_balancer_arn = aws_alb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.alb_target_group.arn
    }
}

resource "aws_alb_listener" "alb-listener-443" {
    load_balancer_arn = aws_alb.alb.arn
    port = 443
    protocol = "HTTPS"

    ssl_policy = "ELBSecurityPolicy-2016-08" # SSL/TLS 프로토콜 버전
    certificate_arn = data.aws_acm_certificate.certificate.arn # SSL/TLS 인증서 ARN

    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.alb_target_group.arn
    }
}

# ALB Target Group 생성
resource "aws_alb_target_group" "alb_target_group" {
    name = "aws-alb-tg-${var.stage}-${var.servicename}"
    port = var.port
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = var.target_type

    health_check {
        path = var.hc_path
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 5
        healthy_threshold = var.hc_healty_threshold
        unhealthy_threshold = var.hc_unhealty_threshold
    }

    tags = merge(tomap({
        Name = "aws-alb-tg-${var.stage}-${var.servicename}"}),
        var.tags
    )
}

# ALB 보안그룹 생성
resource "aws_security_group" "sg-alb" {
    name = "aws-alb-${var.stage}-${var.servicename}"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = var.sg_allow_comm_list
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = var.sg_allow_comm_list
        # self = true # 내부 통신을 원하면 주석 해제
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(tomap({
        Name = "sg-alb-${var.stage}-${var.servicename}"}),
        var.tags
    )
}

resource "aws_security_group" "sg-alb-to-tg" {
  name = "aws-alb-to-tg-${var.stage}-${var.servicename}"
  vpc_id = var.vpc_id

  ingress {
    from_port = var.port
    to_port = var.port
    protocol = "TCP"
    security_groups = [aws_security_group.sg-alb.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(tomap({
    Name = "sg-alb-to-tg-${var.stage}-${var.servicename}"}),
    var.tags
  )
}