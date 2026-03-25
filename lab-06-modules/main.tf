terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Call the reusable module — dev bucket
module "dev_bucket" {
  source            = "../modules/s3-bucket"
  bucket_name       = "my-app-dev-2026"
  environment       = "dev"
  enable_versioning = false
}

# Call it again — prod bucket, same module, different inputs
module "prod_bucket" {
  source            = "../modules/s3-bucket"
  bucket_name       = "my-app-prod-2026"
  environment       = "prod"
  enable_versioning = true
}
