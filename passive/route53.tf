resource "aws_route53_record" "www" {
  zone_id = "Z019754327S3CNAALMH36"
  name    = "www"
  type    = "CNAME"
  ttl     = 60
  records = ["aa1dc4d81d728482cb17830add8e50c9-40176004.us-east-1.elb.amazonaws.com"]
}


