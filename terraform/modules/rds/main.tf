resource "aws_db_instance" "reservation_info" {
  identifier           = "reservation-info-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  username             = "admin"
  password             = var.db_password  # 変数を使用してパスワードを設定
  db_subnet_group_name = aws_db_subnet_group.rds_mysql.name
  vpc_security_group_ids = [var.security_group_rds_sg_id]
  skip_final_snapshot  = true
  multi_az             = false  # 検証環境:false, 本番環境:true

  tags = {
    Name = "Reservation_info RDS Instance"
  }
}

resource "aws_db_subnet_group" "rds_mysql" {
  name       = "${var.studio_name}-rds-subnet-group"
  subnet_ids = [var.private_subnet_1a_id, var.private_subnet_1c_id]

  tags = {
    Name = "${var.studio_name}-rds-subnet-group"
  }
}