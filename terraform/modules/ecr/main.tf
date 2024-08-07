# ECRリポジトリ(Lambdaイメージコンテナ用)
resource "aws_ecr_repository" "zebra_reservation_form" {
  name  = "zebra-reservation-form"

  image_scanning_configuration {
      scan_on_push = true
  }
}