variable "aws_region" {
  description = "AWS region. Hyderabad is ap-south-2."
  type        = string
  default     = "ap-south-2"
}

variable "project_name" {
  description = "Project/application name."
  type        = string
  default     = "ssvd-report-store"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}

variable "container_port" {
  description = "Container HTTP port."
  type        = number
  default     = 3000
}

variable "desired_count" {
  description = "Number of Fargate tasks."
  type        = number
  default     = 1
}

variable "cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 512
}

variable "memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 1024
}

variable "image_tag" {
  description = "Docker image tag deployed to ECS."
  type        = string
  default     = "latest"
}

variable "enable_ecs_service" {
  description = "Set false for first apply to create ECR before image build."
  type        = bool
  default     = true
}

variable "s3_prefix" {
  description = "S3 object prefix used by the app."
  type        = string
  default     = "ssvd-report-store/prod"
}

variable "openai_model" {
  description = "OpenAI model name passed to app."
  type        = string
  default     = "gpt-5.2"
}

variable "claude_model" {
  description = "Claude model name passed to app."
  type        = string
  default     = "claude-sonnet-4-5"
}

variable "official_https_proxy" {
  description = "Optional outbound proxy for official portals."
  type        = string
  default     = ""
  sensitive   = true
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN for HTTPS listener. Leave empty for HTTP-only."
  type        = string
  default     = ""
}

variable "github_owner" {
  description = "GitHub organization/user."
  type        = string
  default     = "sruthishtechnologies"
}

variable "github_infra_repo" {
  description = "Infra repo name."
  type        = string
  default     = "ssvd-report-store-infra-ops"
}

variable "github_app_repo" {
  description = "App repo name."
  type        = string
  default     = "ssvd-report-store"
}

variable "create_github_oidc_role" {
  description = "Create IAM OIDC role for GitHub Actions."
  type        = bool
  default     = true
}
