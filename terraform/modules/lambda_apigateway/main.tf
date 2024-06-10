# Lambdaイメージコンテナ
resource "aws_ecr_repository" "zebra-reservation-form" {
    name                 = "zebra-reservation-form"

    image_scanning_configuration {
        scan_on_push = true
    }
}

# Lambda IAM Role
resource "aws_iam_role" "LambdaSESMailRole" {
    name                 = "LambdaSESMailRole"
    assume_role_policy = data.aws_iam_policy_document.LambdaSESMailRole-assume.json

    description = "Allows Lambda functions to call AWS services on your behalf."

    inline_policy {
        name   = "SendSESPolicy"
        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
			    {
                    Action      = [
				    "ses:SendEmail",
				    "ses:SendRawEmail"
			        ]
                    Effect      = "Allow"
			        Resource    = "*"
                },
            ]
        })
    }

    managed_policy_arns  = ["arn:aws:iam::aws:policy/AmazonSESFullAccess", "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
    max_session_duration = "3600"
    path                 = "/"
}

data "aws_iam_policy_document" "LambdaSESMailRole-assume" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}
# APIGateway_logs
resource "aws_iam_role" "APIGateway_logs" {
    name                 = "APIGateway_logs"
    assume_role_policy = data.aws_iam_policy_document.APIGatewayLogs-assume.json

    description          = "Allows API Gateway to push logs to CloudWatch Logs."
    managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"]
    max_session_duration = "3600"
    path                 = "/"
}

data "aws_iam_policy_document" "APIGatewayLogs-assume" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["apigateway.amazonaws.com"]
        }
    }
}


# Lamnda Function
resource "aws_lambda_function" "reservationform-send-mail" {
    function_name = "reservationform-send-mail"
    image_uri     = "${aws_ecr_repository.zebra-reservation-form.repository_url}:latest"
    architectures = ["arm64"]
    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/reservationform-send-mail"
    }

    package_type                   = "Image"
    role                           = aws_iam_role.LambdaSESMailRole.arn
    skip_destroy                   = "false"
    source_code_hash               = "eea5831a21f203b224398ec121bd473154ea72f0721565005f1f5895c0a57601"
    timeout                        = "3"

    lifecycle {
        ignore_changes = [image_uri]
    }
}

# APIGateway
resource "aws_api_gateway_rest_api" "SendMailAPI" {
  name        = "SendMailAPI"
  description = "スタジオゼブラの予約フォームから入力データを取得するAPI"
}

resource "aws_api_gateway_resource" "SendMailAPI" {
  rest_api_id = aws_api_gateway_rest_api.SendMailAPI.id
  parent_id   = aws_api_gateway_rest_api.SendMailAPI.root_resource_id
  path_part   = "send"
}

resource "aws_api_gateway_method" "SendMailAPI-POST" {
  rest_api_id   = aws_api_gateway_rest_api.SendMailAPI.id
  resource_id   = aws_api_gateway_resource.SendMailAPI.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "SendMailAPI-OPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.SendMailAPI.id
  resource_id   = aws_api_gateway_resource.SendMailAPI.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "SendMailAPI-POST" {
    rest_api_id             = aws_api_gateway_rest_api.SendMailAPI.id
    resource_id             = aws_api_gateway_resource.SendMailAPI.id
    http_method             = aws_api_gateway_method.SendMailAPI-POST.http_method

    integration_http_method = "POST"
    type                    = "AWS"
    uri                     = aws_lambda_function.reservationform-send-mail.invoke_arn
    content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration" "SendMailAPI-OPTIONS" {
    rest_api_id             = aws_api_gateway_rest_api.SendMailAPI.id
    resource_id             = aws_api_gateway_resource.SendMailAPI.id
    http_method             = aws_api_gateway_method.SendMailAPI-OPTIONS.http_method

    integration_http_method = "POST"
    type                    = "AWS"
    uri                     = aws_lambda_function.reservationform-send-mail.invoke_arn
    request_parameters      = {}
    request_templates       = {}
    cache_key_parameters    = []
    content_handling        = "CONVERT_TO_TEXT"

}

resource "aws_api_gateway_deployment" "SendMailAPI-POST" {
  depends_on = [aws_api_gateway_integration.SendMailAPI-POST]

  rest_api_id = aws_api_gateway_rest_api.SendMailAPI.id
}

resource "aws_api_gateway_deployment" "SendMailAPI-OPTIONS" {
  depends_on = [aws_api_gateway_integration.SendMailAPI-OPTIONS]

  rest_api_id = aws_api_gateway_rest_api.SendMailAPI.id
}

# Lambda Trigger 
resource "aws_lambda_permission" "ApiGateway-post" {
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.reservationform-send-mail.arn
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_api_gateway_rest_api.SendMailAPI.execution_arn}/*/${aws_api_gateway_method.SendMailAPI-POST.http_method}/${aws_api_gateway_resource.SendMailAPI.path_part}"
}

resource "aws_lambda_permission" "ApiGateway-option" {
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.reservationform-send-mail.arn
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_api_gateway_rest_api.SendMailAPI.execution_arn}/*/${aws_api_gateway_method.SendMailAPI-OPTIONS.http_method}/${aws_api_gateway_resource.SendMailAPI.path_part}"
}
