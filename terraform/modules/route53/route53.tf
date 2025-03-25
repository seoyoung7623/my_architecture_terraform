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
    evaluate_target_health = true
  }
}
