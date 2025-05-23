data "aws_route53_zone" "seoyoungstudy" {
  name         = "seoyoungstudy.shop"
  private_zone = false
}

resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.seoyoungstudy.zone_id         # 도메인 호스팅 영역 ID
  name    = var.host_name              # 연결할 도메인 이름
  type    = var.record_type             # 레코드 유형

  alias {
    name                   = var.alb_dns_name   # ALB DNS 주소
    zone_id                = var.alb_zone_id    # ALB의 호스팅 영역 ID
    evaluate_target_health = true               # ALB의 상태를 평가하여 상태가 정상이면 트래픽을 전달
  }
}

resource "aws_route53_record" "frontend_alias" {
  zone_id = data.aws_route53_zone.seoyoungstudy.zone_id
  name    = var.dev_domain_name
  type    = var.record_type

  alias {
    name                   = var.front_dns_name
    zone_id                = var.front_hosted_zone_id
    evaluate_target_health = false 
  }
}

