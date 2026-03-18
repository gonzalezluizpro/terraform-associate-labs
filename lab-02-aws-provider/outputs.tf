output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.lab_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.lab_bucket.arn
}

output "bucket_region" {
  description = "Region where bucket was created"
  value       = aws_s3_bucket.lab_bucket.region
}

output "object_key" {
  description = "Key of the uploaded object"
  value       = aws_s3_object.sample_file.key
}
