# SSVD Report Store Infra Ops

Infrastructure-as-code for deploying SSVD Report Store on AWS ECS Fargate in India Hyderabad (`ap-south-2`).

## What This Creates

- ECR repository for the app Docker image
- S3 bucket for generated reports, PDFs, images, JSON exports and ZIP files
- DynamoDB table for app metadata:
  - users
  - roles
  - permissions
  - admin notice
  - saved report index/state
  - document metadata
- Secrets Manager secret for app credentials/API keys
- Low-cost public ECS Fargate deployment:
  - VPC
  - public subnets
  - internet gateway
  - Application Load Balancer
  - ECS cluster/service/task definition
  - CloudWatch logs
  - IAM task execution/task roles
- Optional GitHub OIDC role for Actions deployments

## One-Time Bootstrap

Terraform remote state must exist before GitHub Actions can safely manage infra.

Run once from your machine or any trusted AWS admin shell:

```bash
cd bootstrap
terraform init
terraform apply \
  -var='aws_region=ap-south-2' \
  -var='state_bucket_name=<unique-state-bucket-name>' \
  -var='lock_table_name=ssvd-report-store-tf-locks'
```

Then add these GitHub repository secrets:

```text
TF_STATE_BUCKET=<unique-state-bucket-name>
TF_STATE_LOCK_TABLE=ssvd-report-store-tf-locks
```

For the first deploy, add either:

```text
AWS_ACCESS_KEY_ID=<temporary deploy access key>
AWS_SECRET_ACCESS_KEY=<temporary deploy secret key>
```

or:

```text
AWS_GITHUB_ACTIONS_ROLE_ARN=<role arn allowed to deploy infra>
```

The Terraform stack can create the long-term GitHub OIDC role and outputs `github_actions_role_arn`. After the first deploy, set `AWS_GITHUB_ACTIONS_ROLE_ARN` to that output and remove access-key secrets.

## GitHub Actions

### PR Checks

`.github/workflows/pr-checks.yml`

- Terraform format check
- Terraform validate

### Deploy

`.github/workflows/deploy.yml`

On push to `main` or manual dispatch:

1. Applies infrastructure foundation with ECS service disabled so ECR exists.
2. Checks out app repo `sruthishtechnologies/ssvd-report-store`.
3. Builds Docker image from the app repo.
4. Validates server JavaScript inside the built image.
5. Pushes image to ECR with commit SHA and `latest` tags.
6. Applies Terraform again with ECS service enabled and the new image tag.

## Required App Branch

The app repo must include the AWS/Fargate branch changes:

```text
sruthishtechnologies/ssvd-report-store:aws_fargate
```

The workflow default uses `aws_fargate` as `APP_REF`. After merging that branch to app `main`, change `APP_REF` to `main`.

## Cost Notes

This stack avoids NAT Gateways to reduce cost. Fargate tasks run in public subnets with public IPs and least-privilege security groups.

Main recurring costs:

- Fargate task
- Application Load Balancer
- S3 storage/requests
- DynamoDB on-demand reads/writes
- CloudWatch logs
- ECR storage

## App-Compatible Environment Variables

Terraform injects:

```text
NODE_ENV=production
HOST=0.0.0.0
PORT=3000
STORAGE_MODE=aws
AWS_REGION=ap-south-2
AWS_DYNAMODB_TABLE=<table>
AWS_S3_BUCKET=<bucket>
AWS_S3_PREFIX=<prefix>
AWS_SECRETS_ID=<secret arn>
PLAYWRIGHT_MODULE_URL=playwright
```

## Secrets Manager

Terraform creates the secret shell. Add values in AWS Secrets Manager after deploy:

```json
{
  "ADMIN_USERNAME": "admin",
  "ADMIN_PASSWORD": "change-this-password",
  "OPENAI_API_KEY": "",
  "ANTHROPIC_API_KEY": "",
  "OFFICIAL_HTTPS_PROXY": ""
}
```

## Health Check

The ECS target group uses:

```text
/api/health
```

Expected production response includes:

```json
{
  "ok": true,
  "storageMode": "aws-s3-dynamodb",
  "awsRegion": "ap-south-2"
}
```
