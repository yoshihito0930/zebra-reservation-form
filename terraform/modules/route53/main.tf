# ホストゾーン
resource "aws_route53_zone" "hostzone-zebra" {
  comment       = "HostedZone created by Route53 Registrar"
  force_destroy = "false"
  name          = var.host_name
}

# レコード
resource "aws_route53_record" "studiozebra-1st-dev-NS" {
  name                             = var.host_name
  records                          = ["ns-1390.awsdns-45.org.", "ns-1913.awsdns-47.co.uk.", "ns-284.awsdns-35.com.", "ns-792.awsdns-35.net."]
  ttl                              = "172800"
  type                             = "NS"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

resource "aws_route53_record" "studiozebra-1st-dev-SOA" {
  name                             = var.host_name
  records                          = ["ns-1913.awsdns-47.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  ttl                              = "900"
  type                             = "SOA"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

resource "aws_route53_record" "studiozebra-1st-dev-CNAME-1" {
  name                             = "od2probuhkhsyeyutxepl2tvljzx3kdv._domainkey.${var.host_name}"
  records                          = ["od2probuhkhsyeyutxepl2tvljzx3kdv.dkim.amazonses.com"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

resource "aws_route53_record" "studiozebra-1st-dev-CNAME-2" {
  name                             = "u4dlvlrx7veabv4mex4naihdo47i2ig2._domainkey.${var.host_name}"
  records                          = ["u4dlvlrx7veabv4mex4naihdo47i2ig2.dkim.amazonses.com"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

resource "aws_route53_record" "studiozebra-1st-dev-CNAME-3" {
  name                             = "zp4bu6bgkmmzqcvpc7h4rgzxzgkudlkv._domainkey.${var.host_name}"
  records                          = ["zp4bu6bgkmmzqcvpc7h4rgzxzgkudlkv.dkim.amazonses.com"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

resource "aws_route53_record" "studiozebra-1st-dev-CNAME-4" {
  name                             = "_e1395cf84e22a22cab3985d73e2ee604.${var.host_name}"
  records                          = ["_e30ad9709cdfc43f6bfcf1094a05ac36.mhbtsbpdnt.acm-validations.aws."]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

resource "aws_route53_record" "studiozebra-1st-dev-CNAME-5" {
  name                             = "_e1395cf84e22a22cab3985d73e2ee604.${var.host_name}.${var.host_name}"
  records                          = ["_e30ad9709cdfc43f6bfcf1094a05ac36.mhbtsbpdnt.acm-validations.aws."]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

resource "aws_route53_record" "studiozebra-1st-dev-A" {
  alias {
    evaluate_target_health = "false"
    name                   = "d3g894tijse4w5.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }

  name                             = "reservation-form.${var.host_name}"
  type                             = "A"
  zone_id                          = "${aws_route53_zone.hostzone-zebra.zone_id}"
}

