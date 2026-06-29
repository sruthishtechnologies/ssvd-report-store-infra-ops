# SSVD Report Store Infra Ops

Infrastructure-as-code for deploying SSVD Report Store on a low-cost AWS EC2 Docker host with AWS-native storage.

## What This Creates

- ECR repository for the app Docker image
- EC2 instance running Docker
- Elastic IP for a stable public URL
- VPC, public subnet, internet gateway and security group
- S3 bucket for generated reports, PDFs, images, JSON exports and ZIP files
- DynamoDB table for app metadata:
  - users
  - roles
  - permissions
  - admin notice
  - saved report index/state
  - document metadata
- Secrets Manager secret for app credentials/API keys
- IAM roles for:
  - EC2 runtime access to ECR, S3, DynamoDB, Secrets Manager and SSM
  - optional GitHub OIDC deployments

This stack avoids NAT Gateways and load balancers to keep monthly cost low.

## One-Time Bootstrap

Terraform remote state must exist before GitHub Actions can safely manage infra.

Run once from your machine or any trusted AWS admin shell:

```bash
cd bootstrap
terraform init
terraform apply \
  -var='aws_region=ap-south-1' \
  -var='state_bucket_name=ssvd-report-store-tf-state-824090260951' \
  -var='lock_table_name=ssvd-report-store-tf-locks'
```

Then add these GitHub repository secrets in the infra repo:

```text
TF_STATE_BUCKET=ssvd-report-store-tf-state-824090260951
TF_STATE_LOCK_TABLE=ssvd-report-store-tf-locks
```

For the first deploy, add either temporary access keys:

```text
AWS_ACCESS_KEY_ID=<temporary deploy access key>
AWS_SECRET_ACCESS_KEY=<temporary deploy secret key>
```

or the OIDC role after it exists:

```text
AWS_GITHUB_ACTIONS_ROLE_ARN=<role arn allowed to deploy infra>
```

## GitHub Actions

### PR Checks

`.github/workflows/pr-checks.yml`

- Terraform format check
- Terraform validate

### Deploy Infra And Container

`.github/workflows/deploy.yml`

On push to `main` when Terraform files change, or manual dispatch:

1. Applies Terraform.
2. Reads `terraform/image.auto.tfvars` for the desired Docker image tag.
3. If the image tag is not `latest`, deploys the container to EC2 using AWS SSM.
4. Prints the EC2 Elastic IP app URL.

For the first infra deploy, run manually with:

```text
deploy_container=false
```

That creates EC2/EIP/ECR/S3/DynamoDB/Secrets/IAM before any app image exists.

## App Release Flow

The app repo workflow `.github/workflows/release-image.yml` does the application release:

1. Runs when app code is pushed to `main`.
2. Builds the Docker image.
3. Validates `src/server.js` and `src/public/app.js` inside the image.
4. Pushes tags `<app-commit-sha>` and `latest` to ECR.
5. Commits this line to the infra repo:

```hcl
image_tag = "<app-commit-sha>"
```

6. The infra repo push triggers this deploy workflow.
7. The workflow uses SSM to pull the new ECR image and restart Docker on EC2.

Required app repo secrets:

```text
AWS_GITHUB_ACTIONS_ROLE_ARN=<github actions deploy role arn>
INFRA_REPO_TOKEN=<classic PAT or fine-grained token with contents:write on infra repo>
```

If not using OIDC, add these app repo secrets instead of `AWS_GITHUB_ACTIONS_ROLE_ARN`:

```text
AWS_ACCESS_KEY_ID=<deploy access key>
AWS_SECRET_ACCESS_KEY=<deploy secret key>
```

Optional app repo variables:

```text
AWS_REGION=ap-south-1
ECR_REPOSITORY=ssvd-report-store-prod
INFRA_BRANCH=main
```

## App Environment

The EC2 container receives:

```text
NODE_ENV=production
HOST=0.0.0.0
PORT=3000
STORAGE_MODE=aws
AWS_REGION=ap-south-1
AWS_DYNAMODB_TABLE=<table>
AWS_S3_BUCKET=<bucket>
AWS_S3_PREFIX=ssvd-report-store/prod
AWS_SECRETS_ID=<secret arn>
PLAYWRIGHT_MODULE_URL=playwright
```

## Secrets Manager

Terraform creates the secret shell. Add values in AWS Secrets Manager after deploy:

```json
{
  "ADMIN_USERNAME": "admin",
  "ADMIN_PASSWORD": "SriSatVam@999",
  "OPENAI_API_KEY": "",
  "ANTHROPIC_API_KEY": "",
  "OFFICIAL_HTTPS_PROXY": ""
}
```

## Health Check

Expected production response at `http://<elastic-ip>/api/health` includes:

```json
{
  "ok": true,
  "storageMode": "aws-s3-dynamodb",
  "awsRegion": "ap-south-1"
}
```

## HTTPS Later

This low-cost version starts with HTTP on the Elastic IP. When you are ready for a domain, add Route 53 and either:

- Caddy/Nginx with Let's Encrypt on the EC2 instance, or
- ALB + ACM certificate if you want managed HTTPS.
