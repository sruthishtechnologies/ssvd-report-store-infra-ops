variable "aws_region" {
  description = "AWS region for the low-cost EC2 deployment."
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
  description = "Docker image tag deployed to EC2."
  type        = string
  default     = "latest"
}

variable "ec2_instance_type" {
  description = "Low-cost EC2 instance type for the app host."
  type        = string
  default     = "t3.small"
}

variable "ec2_root_volume_size" {
  description = "EC2 root volume size in GiB."
  type        = number
  default     = 30
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed to access the app over HTTP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
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
