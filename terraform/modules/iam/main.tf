# IAM User
resource "aws_iam_user" "admin" {
    force_destroy = "false"
    name          = var.admin-user
    path          = "/"

    tags = {
        AKIA3X6SIRR5IHDVPPWJ = "github actions"
        AKIA3X6SIRR5KQ677P5E = "wsl"
    }

    tags_all = {
        AKIA3X6SIRR5IHDVPPWJ = "github actions"
        AKIA3X6SIRR5KQ677P5E = "wsl"
    }
}

resource "aws_iam_access_key" "admin-key1" {
    user       = aws_iam_user.admin.name
    status     = "Active"
}

resource "aws_iam_access_key" "admin-key2" {
    user       = aws_iam_user.admin.name
    status     = "Active"
}

# IAM Groupe
resource "aws_iam_group" "administrator" {
    name = "administrator"
    path = "/"
}

resource "aws_iam_group_policy_attachment" "AdministratorAccess" {
    group      = aws_iam_group.administrator.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Github Actinos User
resource "aws_iam_user" "github_actions_user" {
  name = "github-actions-user"
}

resource "aws_iam_user_policy" "ecr_policy" {
  name   = "ecr-full-access"
  user   = aws_iam_user.github_actions_user.name
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_user_policy" "lambda_policy" {
  name   = "lambda-full-access"
  user   = aws_iam_user.github_actions_user.name
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_user_policy" "apigateway_policy" {
  name   = "apigateway-admin-access"
  user   = aws_iam_user.github_actions_user.name
  policy = data.aws_iam_policy_document.apigateway_policy.json
}

resource "aws_iam_user_policy" "s3_policy" {
  name   = "s3-full-access"
  user   = aws_iam_user.github_actions_user.name
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_user_policy" "cloudfront_policy" {
  name   = "cloudfront-create-invalidation"
  user   = aws_iam_user.github_actions_user.name
  policy = data.aws_iam_policy_document.cloudfront_policy.json
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions   = ["ecr:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions   = ["lambda:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "apigateway_policy" {
  statement {
    actions   = [
      "apigateway:POST",
      "apigateway:PATCH",
      "apigateway:GET",
      "apigateway:PUT"
    ]
    resources = ["arn:aws:apigateway:*::/restapis/*"]
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cloudfront_policy" {
  statement {
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [var.cloudfront_distribution_arn]
  }
}

resource "aws_iam_access_key" "github_actions_access_key" {
  user = aws_iam_user.github_actions_user.name
}

# RDS
resource "aws_iam_role" "rds_iam_role" {
  name = "${var.studio_name}-rds-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.studio_name}-rds-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "rds_iam_role_policy" {
  role       = aws_iam_role.rds_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Systems Manager用のIAMロールの作成
resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Systems Manager用のIAMポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}