terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "rds-project-terraform-state-944368523146"
    key            = "rds-project-terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rds-project-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "rds-project"
      ManagedBy   = "Terraform"
      Environment = "Dev"
    }
  }
}