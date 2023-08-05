data "terraform_remote_state" "domain" {
  backend = "s3"
  config = {
    bucket = "backend-tsubasa"
    key    = "domain/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

resource "aws_route53_record" "alb" {
  zone_id = data.terraform_remote_state.domain.outputs.zone_id
  name    = "alb.${data.terraform_remote_state.domain.outputs.zone_name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}