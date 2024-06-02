# 送信元メールアドレス
resource "aws_ses_domain_identity" "studio-zebra" {
    domain = var.domain_name
}

# フォーム内容の送信先アドレス
resource "aws_ses_email_identity" "recipient-address" {
  email = var.recipient-address
}

resource "aws_ses_configuration_set" "configuration-set" {
  name                       = "my-first-configuration-set"
  reputation_metrics_enabled = "true"
  sending_enabled            = "true"
}