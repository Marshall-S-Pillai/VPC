terraform {
  backend "s3" {
    bucket         = "powertool19087"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true 
  }
}
