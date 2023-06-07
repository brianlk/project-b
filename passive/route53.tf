data "aws_route53_zone" "selected" {
  name         = "bbnextmon.com."
  private_zone = false
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 60
  records = ["aa1dc4d81d728482cb17830add8e50c9-40176004.us-east-1.elb.amazonaws.com"]
}


