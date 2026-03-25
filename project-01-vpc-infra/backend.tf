terraform {
  backend "s3" {
    bucket         = "your-tf-state-bucket"
    key            = "project-01-vpc-infra/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
