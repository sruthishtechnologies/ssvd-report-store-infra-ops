output "aws_region" {
  value = var.aws_region
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_data.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.app.name
}

output "secrets_manager_secret_arn" {
  value = aws_secretsmanager_secret.app.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.app.name
}

output "ecs_service_name" {
  value = var.enable_ecs_service ? aws_ecs_service.app[0].name : ""
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "app_url" {
  value = "http://${aws_lb.app.dns_name}"
}

output "github_actions_role_arn" {
  value = var.create_github_oidc_role ? aws_iam_role.github_actions[0].arn : ""
}
