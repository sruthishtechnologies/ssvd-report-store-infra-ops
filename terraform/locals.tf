data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  app_image = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"

  app_environment = {
    NODE_ENV              = "production"
    HOST                  = "0.0.0.0"
    PORT                  = tostring(var.container_port)
    STORAGE_MODE          = "aws"
    AWS_REGION            = var.aws_region
    AWS_DYNAMODB_TABLE    = aws_dynamodb_table.app.name
    AWS_S3_BUCKET         = aws_s3_bucket.app_data.bucket
    AWS_S3_PREFIX         = var.s3_prefix
    AWS_SECRETS_ID        = aws_secretsmanager_secret.app.arn
    PLAYWRIGHT_MODULE_URL = "playwright"
    OPENAI_MODEL          = var.openai_model
    OPENAI_VISION_MODEL   = var.openai_model
    CLAUDE_MODEL          = var.claude_model
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Region      = var.aws_region
  }
}
