terraform {
  backend "s3" {
    bucket         = "powertool9087"
    region         = "us-east-1"
    encrypt        = true
    versioning     = true
    dynamodb_table = "powertool"
  }
}
