variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
  default     = "terraform-lab-02-luiz-2026" # ← change yourname
}

variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "dev"
}
