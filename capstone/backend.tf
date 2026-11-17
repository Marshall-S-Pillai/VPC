# Bootstrap this bucket before running terraform init.
# Create it once with the AWS CLI or a separate bootstrap stack.
terraform {
  backend "s3" {
    bucket       = "REPLACE_WITH_YOUR_UNIQUE_TF_STATE_BUCKET"
    key          = "hcltech-capstone/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
