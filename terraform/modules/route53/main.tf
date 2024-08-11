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
    name                   = var.cloudfront_distribution_name
    zone_id                = var.cloudfront_distribution_hosted_zone_id
  }

  name                             = "${var.host_name}"
  type                             = "A"
  zone_id                          = aws_route53_zone.hostzone-zebra.zone_id
}

# ACM
resource "aws_acm_certificate" "cert" {
  provider          = aws.acm_provider
  domain_name       = "${var.host_name}"
  validation_method = "DNS"

  subject_alternative_names = ["*.studiozebra-1st-dev.com"]

  tags = {
    Name            = var.host_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Route 53 でのドメイン検証レコードの設定
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hostzone-zebra.zone_id
}

# 証明書の検証完了を待つ
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}