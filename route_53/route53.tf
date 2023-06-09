data "aws_route53_zone" "selected" {
  name         = "bbnextmon.com."
  private_zone = false
}

locals {
  active_lb = "a1cb37503051345c1b84495903204964-1519678091.us-east-1.elb.amazonaws.com"
  passive_lb = "a4879d81c3f93470db798bd8abd1096c-963030043.us-west-1.elb.amazonaws.com"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 60
  records = [terraform.workspace == "active" ? local.active_lb: local.passive_lb]
}
