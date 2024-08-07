# ECSクラスター
resource "aws_ecs_cluster" "main" {
  name = "rds-access-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# タスク定義
resource "aws_ecs_task_definition" "bastion_task" {
  family                   = "bastion-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "bastion"
      image     = "${var.repository_url}:bastion"
      essential = true
      command   = ["/bin/sh", "/run.sh"]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/bastion-task"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "bastion_service" {
  name            = "bastion-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.bastion_task.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.private_subnet_1a_id, var.private_subnet_1c_id]
    security_groups = [var.security_group_ecs_sg_id]
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "bastion_task" {
  name              = "/ecs/bastion-task"
  retention_in_days = 14
}

# IAM Roles
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Logs用のポリシーを追加
resource "aws_iam_role_policy" "cloudwatch_logs_policy" {
  name = "cloudwatch-logs-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.bastion_task.arn}:*"
      }
    ]
  })
}

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

resource "aws_iam_role_policy_attachment" "ecs_task_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_ssm_activation" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ecs_task_rds" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# SSM Service Role (if not already existing)
resource "aws_iam_role" "ssm_service_role" {
  name = "SSMServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_service_role_policy" {
  role       = aws_iam_role.ssm_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# SSM Service Policy
resource "aws_iam_role_policy" "ssm_service_policy" {
  name = "SSMServicePolicy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = "*"
        Condition = {
          StringEquals = {
            "iam:PassedToService": "ssm.amazonaws.com"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:DeleteActivation",
          "ssm:RemoveTagsFromResource",
          "ssm:AddTagsToResource",
          "ssm:CreateActivation"
        ]
        Resource = "*"
      }
    ]
  })
}

# ECS TaskのIAMロールにSSM Activationのポリシーを追加
resource "aws_iam_role_policy" "ssm_activation_policy" {
  name = "ssm-activation-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:CreateActivation",
          "ssm:DeleteActivation",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}