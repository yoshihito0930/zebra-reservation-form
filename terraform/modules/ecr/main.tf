# ECRリポジトリ(Lambdaイメージコンテナ用)
resource "aws_ecr_repository" "zebra_reservation_form" {
  name  = "zebra-reservation-form"

  image_scanning_configuration {
      scan_on_push = true
  }
}

# ECRリポジトリ(Auroraへのポートフォワード用)
resource "aws_ecr_repository" "port_forwarder" {
  name    = "port-forwarder"
  image_scanning_configuration {
      scan_on_push = true
  }
}