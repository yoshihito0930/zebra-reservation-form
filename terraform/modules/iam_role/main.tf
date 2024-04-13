
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