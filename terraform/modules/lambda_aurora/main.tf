# LambdaがAuroraにアクセスするためのIAMロール
resource "aws_iam_role" "lambda_to_aurora_exec_role" {
  name = "${var.studio_name}-lambda-to-aurora-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.studio_name}-lambda-to-aurora-exec-role"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_to_aurora_exec_policy" {
  role       = aws_iam_role.lambda_to_aurora_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

/*
  # DB操作のためのLambda Function（要編集）
  resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    role          = aws_iam_role.lambda_to_aurora_exec_role.arn
    handler       = "index.handler"
    runtime       = "nodejs14.x"
    filename      = "lambda_function_payload.zip"

    vpc_config {
      subnet_ids         = [var.public_subnet_1a, var.public_subnet_1c]
      security_group_ids = [aws_security_group.lambda_sg.id]
    }

    environment {
      variables = {
        DB_HOST     = aws_rds_cluster.aurora.endpoint
        DB_USER     = var.db_username
        DB_PASSWORD = var.db_password
        DB_NAME     = var.db_name
      }
    }

    tags = {
      Name = "${var.studio_name}-lambda"
    }
  }
*/