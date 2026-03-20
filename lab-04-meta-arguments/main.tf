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

# ── locals: built-in functions in action ──────────────────────

locals {
  # format() + lower() to build bucket names
  bucket_names = {
    for env, config in var.buckets :
    env => format("tf-lab03-%s-%s-2026", lower(var.owner), env)
  }

  # merge() to combine common tags with per-bucket tags
  bucket_tags = {
    for env, config in var.buckets :
    env => merge(var.common_tags, {
      Name        = local.bucket_names[env]
      Environment = config.environment
    })
  }
}

# ── for_each: one bucket per map key ──────────────────────────

resource "aws_s3_bucket" "multi" {
  for_each = var.buckets
  bucket   = local.bucket_names[each.key]
  tags     = local.bucket_tags[each.key]

  lifecycle {
    # Only prod bucket config has prevent_del = true
    # We use prevent_destroy = false for lab safety — toggle to test
    prevent_destroy = false
  }
}

# ── for_each on a dependent resource (PAB per bucket) ─────────

resource "aws_s3_bucket_public_access_block" "pab" {
  for_each = var.buckets

  bucket                  = aws_s3_bucket.multi[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ── for_each: versioning only where enabled ───────────────────

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = { for k, v in var.buckets : k => v if v.versioning == true }

  bucket = aws_s3_bucket.multi[each.key].id

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket_public_access_block.pab]
}

# ── count example: create N log files (count.index demo) ──────

resource "local_file" "env_log" {
  count    = length(keys(var.buckets))
  filename = "${path.module}/logs/env-${count.index}.txt"
  content  = "Log for bucket index ${count.index} — created by Terraform"
}
