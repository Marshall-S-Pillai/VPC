# HCLTech Terraform Capstone

This self-contained capstone stack deploys a VPC, public subnet, internet gateway, route table, restricted security group, an EC2 instance via a Terraform Registry module, and a private/versioned/encrypted S3 application bucket.

## Requirements covered

- Terraform configuration, variables and outputs
- EC2 deployment using the Registry module `terraform-aws-modules/ec2-instance/aws`
- S3 application bucket with versioning, encryption and public-access blocking
- S3 remote state backend with native state locking
- Dev/Prod workspace support (see commands below)
- `terraform fmt`, `validate`, `plan` and `apply`

## Important: bootstrap the state bucket first

The S3 backend bucket must exist before `terraform init`. Create a dedicated bucket (do not reuse or overwrite the existing `powertool2027` bucket/state unless you intentionally want to), enable versioning and block public access. Then replace the placeholder bucket name in `backend.tf`.

Example bucket creation (choose a globally unique name):
```bash
aws s3api create-bucket --bucket YOUR-UNIQUE-TF-STATE-BUCKET --region us-east-1
aws s3api put-bucket-versioning --bucket YOUR-UNIQUE-TF-STATE-BUCKET --versioning-configuration Status=Enabled
aws s3api put-public-access-block --bucket YOUR-UNIQUE-TF-STATE-BUCKET --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

## Deploy

Run from this directory. Configure AWS credentials using an IAM role or AWS CLI profile. Do not commit credentials.

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and set `allowed_ssh_cidr` to your own public IP with /32.
2. Replace the backend bucket placeholder in `backend.tf`.
3. Run:
```bash
terraform fmt -recursive
terraform init
terraform validate
terraform workspace new dev   # or: terraform workspace select dev
terraform plan -out=tfplan
terraform apply tfplan
terraform output
```

For prod, use a separate backend key/state (recommended) or carefully configure a workspace key prefix. Do not deploy dev and prod into the same state. Review every plan before applying.

## Cleanup

After evidence collection, run `terraform destroy` from the same workspace if you no longer need the resources. The application bucket is intentionally not force-destroyed; empty it first. Do not delete the remote state bucket until all state is no longer needed.

## Evidence for submission

Capture successful output for `terraform init`, `terraform fmt -check`, `terraform validate`, `terraform workspace list`, `terraform plan`, `terraform apply`, plus AWS console evidence for EC2 and both S3 buckets (state and application).
