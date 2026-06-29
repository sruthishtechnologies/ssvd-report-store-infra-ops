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

output "apprunner_service_name" {
  value = var.create_apprunner_service ? aws_apprunner_service.app[0].service_name : ""
}

output "apprunner_service_arn" {
  value = var.create_apprunner_service ? aws_apprunner_service.app[0].arn : ""
}

output "apprunner_service_url" {
  value = var.create_apprunner_service ? "https://${aws_apprunner_service.app[0].service_url}" : ""
}

output "app_url" {
  value = var.create_apprunner_service ? "https://${aws_apprunner_service.app[0].service_url}" : ""
}

output "github_actions_role_arn" {
  value = var.create_github_oidc_role ? aws_iam_role.github_actions[0].arn : ""
}
