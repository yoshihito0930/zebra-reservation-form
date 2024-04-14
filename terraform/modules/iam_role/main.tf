# CloudFront invalidation cash Policy
data "aws_iam_policy_document" "cloudfront_cash_invalidation" {
    statement {
			effect   = "Allow"
			action   = ["cloudfront:CreateInvalidation"] # CloudFrontのキャッシュを無効化する
			resource = ["arn:aws:cloudfront::807357942906:distribution/E36NOONM5TQTGN"]
		}
}

resource "aws_iam_policy" "add_create_invalidation" {
    name   = "add_create_invalidation"
    policy = data.aws_iam_policy_document.cloudfront_cash_invalidation.json
}

# SES send Policy
data "aws_iam_policy_document" "ses_send_mail" {
    statement {
			effect   = "Allow"
			action   = ["ses:SendEmail", "ses:SendRawEmail"] 
			resource = ["*"]
		}
}

# AWS管理ポリシー(SESFullAccess)
data "aws_iam_policy" "AmazonSESFullAccess" {
    arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# AWS管理ポリシー(LambdaBasicExecutionRole)
data "aws_iam_policy" "AmazonSESFullAccess" {
    arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_policy" "SendSESPolicy" {
    name   = "SendSESPolicy"
    policy = data.aws_iam_policy_document.ses_send_mail.json
}

