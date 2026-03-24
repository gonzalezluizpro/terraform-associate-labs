terraform {
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # No backend block here — uses local state intentionally
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-state-luiza-lab05-2026"   # ← must be globally unique

  lifecycle {
    prevent_destroy = true   # Never accidentally delete your state bucket
  }

  tags = {
    Name      = "Terraform State Bucket"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"   # Keeps history of every state version
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"   # SSE-S3 encryption at rest
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.id
}
