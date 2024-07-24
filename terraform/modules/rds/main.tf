resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = var.db_identifier
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.07.0"
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [var.security_group_aurora_mysql_id]
  skip_final_snapshot     = true
  storage_encrypted       = true
  backup_retention_period = 3  // バックアップを保持する日数
  preferred_backup_window = "00:00-02:00"  // バックアップを実行する時間帯
  preferred_maintenance_window = "sun:05:00-sun:06:00"  // メンテナンスを実行する時間帯


  serverlessv2_scaling_configuration {
    max_capacity             = 1.0
    min_capacity             = 0.5
  }

  tags = {
    Name = "${var.studio_name}-aurora-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier              = "${var.studio_name}-aurora-instance"
  cluster_identifier      = aws_rds_cluster.aurora.id
  instance_class          = "db.serverless"
  engine                  = aws_rds_cluster.aurora.engine
  engine_version          = aws_rds_cluster.aurora.engine_version
  publicly_accessible     = false

  tags = {
    Name = "${var.studio_name}-aurora-instance"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.studio_name}-aurora-subnet-group"
  subnet_ids = [var.private_subnet_1a_id, var.private_subnet_1c_id]

  tags = {
    Name = "${var.studio_name}-aurora-subnet-group"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_pg" {
  name   = "${var.studio_name}-aurora-cluster-pg"
  family = "aurora-mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name = "${var.studio_name}-aurora-cluster-pg"
  }
}