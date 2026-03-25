variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "AZ to deploy the public subnet"
  type        = string
  default     = "eu-west-1a"
}

variable "project_name" {
  description = "Project name used in resource tags"
  type        = string
}
