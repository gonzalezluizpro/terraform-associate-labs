variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "buckets" {
  description = "Map of bucket configs: key=short name, value=environment label"
  type = map(object({
    environment = string
    versioning  = bool
    prevent_del = bool
  }))
  default = {
    dev = {
      environment = "development"
      versioning  = false
      prevent_del = false
    }
    staging = {
      environment = "pre-production"
      versioning  = true
      prevent_del = false
    }
    prod = {
      environment = "production"
      versioning  = true
      prevent_del = true
    }
  }
}

variable "owner" {
  description = "Owner name used in bucket naming and tags"
  type        = string
  default     = "luiza"
}

variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "terraform-associate-labs"
  }
}
