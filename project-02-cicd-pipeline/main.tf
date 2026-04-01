terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Use HCP Terraform or S3 backend — pipeline needs remote state
  cloud {
    organization = "lux-it-solutions"
    workspaces {
      name = "project-02-cicd-pipeline"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "cicd_demo" {
  bucket = "tf-cicd-demo-${var.environment}-${var.suffix}"
  tags = {
    Name        = "cicd-demo-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform-CICD"
    Pipeline    = "GitHub-Actions"
    Tested      = "Successfully"
  }
}

resource "aws_s3_bucket_public_access_block" "cicd_demo" {
  bucket                  = aws_s3_bucket.cicd_demo.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}