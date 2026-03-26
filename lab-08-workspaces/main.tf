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

# terraform.workspace gives you the active workspace name
locals {
  env = terraform.workspace   # "dev", "staging", or "prod"
}

resource "aws_s3_bucket" "env_bucket" {
  bucket = "tf-lab-09-${local.env}-${var.bucket_suffix}"

  tags = {
    Name        = "tf-lab-09-${local.env}"
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}