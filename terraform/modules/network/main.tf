resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.studio_name}-vpc"
  }
}

// 東京リージョン
resource "aws_subnet" "public_tokyo" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.studio_name}-public-subnet-a"
  }
}

resource "aws_subnet" "private_tokyo" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.studio_name}-private-subnet-a"
  }
}

// 大阪リージョン
resource "aws_subnet" "public_osaka" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-3a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.studio_name}-public-subnet-b"
  }
}

resource "aws_subnet" "private_osaka" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-3a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.studio_name}-private-subnet-b"
  }
}

// RDS VPCエンドポイント (ap-northeast-1)
resource "aws_vpc_endpoint" "rds_northeast_1" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.ap-northeast-1.rds"
  vpc_endpoint_type = "Interface"
  subnet_ids   = [aws_subnet.public_tokyo.id, aws_subnet.private_tokyo.id]

  security_group_ids = [aws_security_group.rds_endpoint_sg.id]

  tags = {
    Name = "${var.studio_name}-rds-endpoint-northeast-1"
  }
}

// RDS VPCエンドポイント (ap-northeast-3)
resource "aws_vpc_endpoint" "rds_northeast_3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.ap-northeast-3.rds"
  vpc_endpoint_type = "Interface"
  subnet_ids   = [aws_subnet.public_osaka.id, aws_subnet.private_osaka.id]

  security_group_ids = [aws_security_group.rds_endpoint_sg.id]

  tags = {
    Name = "${var.studio_name}-rds-endpoint-northeast-3"
  }
}

// セキュリティグループ
resource "aws_security_group" "rds_endpoint_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
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