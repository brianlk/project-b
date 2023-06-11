data "aws_route53_zone" "selected" {
  name         = "bbnextmon.com."
  private_zone = false
}

locals {
  active_lb = "aa21eb33c24634e068b262c25cb861e3-232425130.us-east-1.elb.amazonaws.com"
  passive_lb = "afa79289aa70844c69eee4280cdf26d6-1999554089.us-west-1.elb.amazonaws.com"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 60
  records = [terraform.workspace == "default" ? local.active_lb: local.passive_lb]
}
