data "aws_acm_certificate" "front_certificate" {
  provider = aws.virginia
  domain      = "*.seoyoungstudy.shop"
  statuses    = ["ISSUED"]
  most_recent = true 
}

resource "aws_cloudfront_distribution" "front_distribution" {
  # 어디서 콘테츠를 가져올지
  origin {
    domain_name = var.frontend_bucket_regional_domain_name # 원본 도메인 주소
    origin_id   = var.frontend_bucket_regional_domain_name 

    s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true # 배포 활성화
  is_ipv6_enabled     = true
  comment             = "Frontend distribution"
  default_root_object = "index.html"

  aliases = [var.dev_domain_name]

  # 캐싱 설정
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"] # Cloudfront가 백엔드로 전달할 HTTP 메서드
    cached_methods   = ["GET", "HEAD"] # 캐싱할 HTTP 메서드
    target_origin_id = var.frontend_bucket_regional_domain_name # 어떤 오리진에 대한 캐싱을 할지

    forwarded_values {
      query_string = false # 쿼리 스트링을 포함할지 여부

      cookies {
        forward = "none" # 쿠키를 전달하지 않음
      }
    }

    viewer_protocol_policy = "redirect-to-https" # HTTP 요청을 HTTPS로 리다이렉트
  }

    # 지리적 접근 제한
  restrictions {
    geo_restriction {
      restriction_type = "none" # 제한없음(전 세계 접근 가능)
    }
  }

    # SSL 설정
  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.front_certificate.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = merge(tomap({
    Name = "cloudfront-${var.stage}-${var.servicename}" }),
    var.tags
  )
  
}

# OAI 생성
resource "aws_cloudfront_origin_access_identity" "oai" {
    comment =  "OAI for static site ${var.stage}"
}