terraform {
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Phase 2: Backend now active — bucket was created by bootstrap/
  backend "s3" {
    bucket       = "tf-state-luiza-lab05-2026"
    key          = "lab05/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Add your actual lab resources here (EC2, VPC, etc.)
# NO aws_s3_bucket or aws_dynamodb_table — those live in bootstrap/ only
