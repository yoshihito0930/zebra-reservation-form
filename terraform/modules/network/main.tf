resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.studio_name}-vpc"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false
  depends_on = [aws_vpc.main]

  tags = {
    Name = "${var.studio_name}-public-subnet-ap-northeast-1a"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false
  depends_on = [aws_vpc.main]

  tags = {
    Name = "${var.studio_name}-private-subnet-ap-northeast-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false
  depends_on = [aws_vpc.main]

  tags = {
    Name = "${var.studio_name}-public-subnet-ap-northeast-1c"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false
  depends_on = [aws_vpc.main]

  tags = {
    Name = "${var.studio_name}-private-subnet-ap-northeast-1c"
  }
}

// セキュリティグループ
resource "aws_security_group" "rds_endpoint_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.studio_name}-rds-endpoint-sg"
  }
}

// LambdaとAuroraを接続するためのSG
resource "aws_security_group" "lambda_sg" {
  name        = "${var.studio_name}-lambda-sg"
  description = "Security group for Lambda"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.studio_name}-lambda-sg"
  }
}

resource "aws_security_group_rule" "allow_lambda_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_endpoint_sg.id
  source_security_group_id = aws_security_group.lambda_sg.id
}