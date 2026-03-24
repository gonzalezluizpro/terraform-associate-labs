variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "Globally unique name for the Terraform state S3 bucket"
  type        = string
  default     = "tf-state-luiza-lab05-2026" # ← change to your name
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking (legacy pattern)"
  type        = string
  default     = "terraform-state-locks"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "lab"
}
