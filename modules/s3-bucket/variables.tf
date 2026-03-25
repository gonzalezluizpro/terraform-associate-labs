variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = false
}
