terraform {
  backend "s3" {
    bucket         = "powertool19087" 
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "powertool"
             
  }
}
