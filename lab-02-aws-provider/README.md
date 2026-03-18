# Lab 02 — AWS Provider & S3 Bucket

## What this builds
An AWS S3 bucket using the `hashicorp/aws` provider (~> 5.0) with:
- Public access fully blocked (modern AWS best practice)
- Versioning enabled
- A sample object uploaded via `aws_s3_object`
- Environment tags for resource management

## Architecture
Terraform → AWS Provider → S3 Bucket
├── Public Access Block
├── Versioning Config
└── Object (hello-terraform.txt)


## Key concepts covered
- `required_providers` block with `source` and `version`
- Pessimistic constraint operator `~>` for version pinning
- `provider` block configuration (region via variable)
- Multiple dependent resources using `depends_on`
- Outputs for bucket name, ARN, and region

## Commands
```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply
terraform destroy
