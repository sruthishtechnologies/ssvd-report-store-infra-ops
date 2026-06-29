aws_region   = "ap-south-2"
project_name = "ssvd-report-store"
environment  = "prod"

desired_count = 1
cpu           = 512
memory        = 1024

s3_prefix = "ssvd-report-store/prod"

github_owner      = "sruthishtechnologies"
github_infra_repo = "ssvd-report-store-infra-ops"
github_app_repo   = "ssvd-report-store"
