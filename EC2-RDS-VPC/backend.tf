terraform {
  backend "s3" {
    bucket         = "terraform-state-944368523146"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
