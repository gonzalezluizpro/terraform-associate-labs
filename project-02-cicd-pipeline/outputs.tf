output "bucket_name" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.cicd_demo.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.cicd_demo.arn
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}