provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-data-123"
    key            = "state/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
