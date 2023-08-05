resource "aws_route53_zone" "this" {
  comment           = "HostedZone created by Route53 Registrar"
  delegation_set_id = null
  force_destroy     = null
  name              = "tsinfrapj.net"
  tags              = {}
  tags_all          = {}
}