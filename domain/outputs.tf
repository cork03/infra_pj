output "zone_id" {
  value = aws_route53_zone.this.zone_id
}

output "zone_name" {
  value = aws_route53_zone.this.name
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.this.arn
}