# ECSクラスター
resource "aws_ecs_cluster" "main" {
  name = "${var.studio_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# タスク定義
resource "aws_ecs_task_definition" "port_forwarder" {
  family                   = "port-forwarder"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "port-forwarder"
      image = "${var.port_forwarder_repository_url}:latest"
      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
        }
      ]
      environment = [
        {
          name  = "TARGET_HOST"
          value = var.aurora_endpoint
        },
        {
          name  = "TARGET_PORT"
          value = "3306"
        },
        {
          name  = "LISTEN_PORT"
          value = "3306"
        }
      ]
    }
  ])
}

# ECSサービス
resource "aws_ecs_service" "port_forwarder" {
  name            = "port-forwarder-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.port_forwarder.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [var.private_subnet_1a_id, var.private_subnet_1c_id]
    security_groups = [var.fargate_sg_id]
  }
}

# IAMロール（ECS実行ロール）
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAMロール（ECSタスクロール）
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# SSMセッションマネージャー用のポリシー
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# SSMドキュメント
resource "aws_ssm_document" "port_forward" {
  name            = "SSM-PortForwardingToAurora"
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to establish port forwarding to Aurora MySQL"
    sessionType   = "Port"
    properties  = {
      portNumber      = "3306"
      localPortNumber = "3306"
    }
  })
}