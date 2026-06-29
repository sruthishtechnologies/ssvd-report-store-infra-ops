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

output "ec2_instance_id" {
  value = aws_instance.app.id
}

output "ec2_public_ip" {
  value = aws_eip.app.public_ip
}

output "ec2_elastic_ip_allocation_id" {
  value = aws_eip.app.allocation_id
}

output "app_url" {
  value = "http://${aws_eip.app.public_ip}"
}

output "github_actions_role_arn" {
  value = var.create_github_oidc_role ? aws_iam_role.github_actions[0].arn : ""
}
