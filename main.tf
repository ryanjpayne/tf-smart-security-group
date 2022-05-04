
# Set region and accountIDs

provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = ["1234567890"]
  profile             = "profile"
}

# Configure backend

terraform {
  backend "s3" {
    key            = "state-file"
    encrypt        = true 
    bucket         = ""
    dynamodb_table = ""
    region         = "us-east-1"
    profile        = "profile"
  }
}