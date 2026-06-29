variable "aws_region" {
  description = "AWS region. App Runner is available in Mumbai (ap-south-1); Hyderabad (ap-south-2) is not currently listed in AWS endpoint data."
  type        = string
  default     = "ap-south-1"
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

variable "image_tag" {
  description = "Docker image tag deployed to App Runner."
  type        = string
  default     = "latest"
}

variable "create_apprunner_service" {
  description = "Set false for first apply to create ECR before image build."
  type        = bool
  default     = true
}

variable "apprunner_cpu" {
  description = "App Runner vCPU size."
  type        = string
  default     = "0.25 vCPU"
}

variable "apprunner_memory" {
  description = "App Runner memory size."
  type        = string
  default     = "0.5 GB"
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
