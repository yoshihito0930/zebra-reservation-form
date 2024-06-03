resource "aws_route53_zone" "hostzone-zebra" {
  comment       = "HostedZone created by Route53 Registrar"
  force_destroy = "false"
  name          = "studiozebra-1st-dev.com"
}
