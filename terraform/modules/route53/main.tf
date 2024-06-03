# ホストゾーン
resource "aws_route53_zone" "hostzone-zebra" {
  comment       = "HostedZone created by Route53 Registrar"
  force_destroy = "false"
  name          = var.host_name
}

# レコード
