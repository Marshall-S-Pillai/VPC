terraform {
  backend "s3" {
    bucket         = "powertool2026"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true 
  }
}
