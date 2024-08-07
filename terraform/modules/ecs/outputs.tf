output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

/*
output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.rds_access.arn
}
*/