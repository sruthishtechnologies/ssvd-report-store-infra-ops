aws_region   = "ap-south-1"
project_name = "ssvd-report-store"
environment  = "prod"

ec2_instance_type    = "t3.small"
ec2_root_volume_size = 30
allowed_http_cidrs   = ["0.0.0.0/0"]

s3_prefix = "ssvd-report-store/prod"

github_owner      = "sruthishtechnologies"
github_infra_repo = "ssvd-report-store-infra-ops"
github_app_repo   = "ssvd-report-store"
