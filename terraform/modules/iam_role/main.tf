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

# SESポリシードキュメント
data "aws_iam_policy_document" "ses_send_mail" {
    statement {
			effect   = "Allow"
			action   = ["ses:SendEmail", "ses:SendRawEmail"] 
			resource = ["*"]
		}
}

# SESポリシー
resource "aws_iam_policy" "SendSESPolicy" {
    name   = "SendSESPolicy"
    policy = data.aws_iam_policy_document.ses_send_mail.json
}

# AWS管理ポリシー(SESFullAccess)
data "aws_iam_policy" "AmazonSESFullAccess" {
    arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# AWS管理ポリシー(LambdaBasicExecutionRole)
data "aws_iam_policy" "LambdaBasicExecutionRole" {
    arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 信頼ポリシーの定義(lambda)
data "aws_iam_policy_document" "lambda_assume_role" {
    statement {
        actions         = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

# IAM roleの定義(LambdaSESMailRole)
resource "aws_iam_role" "LambdaSESMailRole" {
    name               = "LambdaSESMailRole"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# IAM roleのアタッチ(LambdaSESMailRole)
resource "aws_iam_role_policy_attachment" "LambdaSESMailRole" {
    role       = aws_iam_role.LambdaSESMailRole.name
    policy_arn = aws_iam_policy.SendSESPolicy.arn
}

resource "aws_iam_role_policy_attachment" "LambdaSESMailRole" {
    role       = aws_iam_role.LambdaSESMailRole.name
    policy_arn = aws_iam_policy.AmazonSESFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "LambdaSESMailRole" {
    role       = aws_iam_role.LambdaSESMailRole.name
    policy_arn = aws_iam_policy.LambdaBasicExecutionRole.arn
}


# AWS管理ポリシー(AmazonAPIGatewayPushToCloudWatchLogs )
data "aws_iam_policy" "AmazonAPIGatewayPushToCloudWatchLogs " {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

# 信頼ポリシーの定義(APIGateway)
data "aws_iam_policy_document" "apigateway_assume_role" {
    statement {
        actions  = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["apigateway.amazonaws.com"]
        }
    }
}

# IAM roleの定義(APIGateway_logs )
resource "aws_iam_role" "APIGateway_logs " {
    name               = "APIGateway_logs "
    assume_role_policy = data.aws_iam_policy_document.apigateway_assume_role.json
}

# IAM roleのアタッチ(APIGateway_logs)
resource "aws_iam_role_policy_attachment" "APIGateway_logs"{
    role       = aws_iam_role.APIGateway_logs.name
    policy_arn = aws_iam_policy.AmazonAPIGatewayPushToCloudWatchLogs.arn
}