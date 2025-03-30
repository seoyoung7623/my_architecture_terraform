output "front_dns_name" {
  value = aws_cloudfront_distribution.front_distribution.domain_name
}

output "front_hosted_zone_id" {
  value = aws_cloudfront_distribution.front_distribution.hosted_zone_id
}