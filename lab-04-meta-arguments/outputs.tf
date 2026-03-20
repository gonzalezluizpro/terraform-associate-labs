# Output all bucket IDs using a for expression
output "bucket_ids" {
  description = "Map of environment → bucket ID"
  value       = { for k, v in aws_s3_bucket.multi : k => v.id }
}

output "bucket_arns" {
  description = "Map of environment → bucket ARN"
  value       = { for k, v in aws_s3_bucket.multi : k => v.arn }
}

output "versioned_buckets" {
  description = "Only the buckets that have versioning enabled"
  value       = { for k, v in aws_s3_bucket_versioning.versioning : k => v.bucket }
}

output "bucket_name_list" {
  description = "Flat list of all bucket names using values() function"
  value       = values(local.bucket_names)
}

output "total_buckets" {
  description = "Total number of buckets created"
  value       = length(aws_s3_bucket.multi)
}
