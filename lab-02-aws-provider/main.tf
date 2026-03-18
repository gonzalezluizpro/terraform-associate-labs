terraform {
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. The S3 Bucket
resource "aws_s3_bucket" "lab_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 2. Block ALL public access (modern AWS best practice)
resource "aws_s3_bucket_public_access_block" "lab_bucket_pab" {
  bucket = aws_s3_bucket.lab_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Enable versioning
resource "aws_s3_bucket_versioning" "lab_bucket_versioning" {
  bucket = aws_s3_bucket.lab_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Upload a sample object
resource "aws_s3_object" "sample_file" {
  bucket  = aws_s3_bucket.lab_bucket.id
  key     = "hello-terraform.txt"
  content = "This file was created by Terraform on Day 2!"

  depends_on = [aws_s3_bucket_public_access_block.lab_bucket_pab]
}
