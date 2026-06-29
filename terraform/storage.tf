resource "aws_ecr_repository" "app" {
  name                 = local.name_prefix
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 20 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 20
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_s3_bucket" "app_data" {
  bucket = "${local.name_prefix}-data-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "app" {
  name         = local.name_prefix
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_secretsmanager_secret" "app" {
  name        = "${local.name_prefix}/app-secrets"
  description = "SSVD Report Store app credentials and API keys"
}

resource "aws_secretsmanager_secret_version" "initial" {
  secret_id = aws_secretsmanager_secret.app.id

  secret_string = jsonencode({
    ADMIN_USERNAME       = "admin"
    ADMIN_PASSWORD       = "CHANGE_ME_IN_SECRETS_MANAGER"
    OPENAI_API_KEY       = ""
    ANTHROPIC_API_KEY    = ""
    OFFICIAL_HTTPS_PROXY = var.official_https_proxy
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}
