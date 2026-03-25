# Lab 06 — Terraform Modules

> **HashiCorp Certified: Terraform Associate 003** | Week 1 · Day 6

## What This Lab Builds

A **reusable `s3-bucket` child module** that is called twice from a root module to provision two AWS S3 buckets — one for `dev` and one for `prod` — with different configurations passed as inputs.

This demonstrates the core module pattern: **define once, reuse with different inputs**.

---

## Architecture

```
terraform-associate-labs/
├── modules/
│   └── s3-bucket/          ← Reusable child module
│       ├── main.tf          ← S3 bucket + PAB + optional versioning
│       ├── variables.tf     ← Input declarations
│       └── outputs.tf       ← Exposed outputs
└── lab-06-modules/          ← Root module (caller)
    ├── main.tf              ← Calls module twice (dev + prod)
    ├── variables.tf
    ├── outputs.tf
    └── README.md
```

```
Root Module (lab-06-modules)
        │
        ├── module "dev_bucket"  ──▶  modules/s3-bucket
        │                              ├── aws_s3_bucket.this
        │                              ├── aws_s3_bucket_public_access_block.this
        │                              └── aws_s3_bucket_versioning.this (skipped: count=0)
        │
        └── module "prod_bucket" ──▶  modules/s3-bucket
                                       ├── aws_s3_bucket.this
                                       ├── aws_s3_bucket_public_access_block.this
                                       └── aws_s3_bucket_versioning.this (count=1)
```

---

## Concepts Covered

| Concept | Where Used |
|---|---|
| Child module declaration | `module "dev_bucket"` block in root `main.tf` |
| `source` (local path) | `source = "../modules/s3-bucket"` |
| Input variables | `variables.tf` in child module |
| Output values | `outputs.tf` — accessed as `module.dev_bucket.bucket_arn` |
| Module versioning | `version` argument (registry only) |
| `terraform init` installs modules | `.terraform/modules/` created on init |
| State addresses | `module.dev_bucket.aws_s3_bucket.this` |

---

## Module Inputs (`modules/s3-bucket/variables.tf`)

| Variable | Type | Default | Description |
|---|---|---|---|
| `bucket_name` | `string` | — | Globally unique S3 bucket name (required) |
| `environment` | `string` | `"dev"` | Deployment environment tag |
| `enable_versioning` | `bool` | `false` | Enables S3 object versioning when `true` |

---

## Module Outputs (`modules/s3-bucket/outputs.tf`)

| Output | Description |
|---|---|
| `bucket_id` | The name/ID of the created S3 bucket |
| `bucket_arn` | The full ARN of the S3 bucket |

> Access from root module: `module.dev_bucket.bucket_arn`

---

## Key Files

### `modules/s3-bucket/main.tf`

```hcl
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

### `lab-06-modules/main.tf`

```hcl
terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "dev_bucket" {
  source            = "../modules/s3-bucket"
  bucket_name       = "my-app-dev-2026"
  environment       = "dev"
  enable_versioning = false
}

module "prod_bucket" {
  source            = "../modules/s3-bucket"
  bucket_name       = "my-app-prod-2026"
  environment       = "prod"
  enable_versioning = true
}
```

### `lab-06-modules/outputs.tf`

```hcl
output "dev_bucket_arn" {
  value = module.dev_bucket.bucket_arn
}

output "prod_bucket_arn" {
  value = module.prod_bucket.bucket_arn
}
```

---

## Commands

```bash
cd lab-06-modules

# Downloads providers AND resolves local modules
terraform init

# Format recursively (includes modules/ folder)
terraform fmt -recursive

# Validate HCL syntax
terraform validate

# Preview — notice module.dev_bucket and module.prod_bucket addresses
terraform plan

# Apply
terraform apply

# Inspect outputs
terraform output

# Check state addresses (module prefix!)
terraform state list

# Clean up
terraform destroy
```

### Expected `terraform state list` output

```
module.dev_bucket.aws_s3_bucket.this
module.dev_bucket.aws_s3_bucket_public_access_block.this
module.prod_bucket.aws_s3_bucket.this
module.prod_bucket.aws_s3_bucket_public_access_block.this
module.prod_bucket.aws_s3_bucket_versioning.this[0]
```

---

## Exam Cheat Sheet — Modules

| Rule | Detail |
|---|---|
| Local path format | Must start with `./` or `../` |
| `version` argument | Only works for **registry** and remote sources, not local paths |
| `terraform init` | Must re-run after adding/changing any module source |
| Output reference | `module.<name>.<output_name>` |
| Public registry format | `namespace/module/provider` e.g. `terraform-aws-modules/vpc/aws` |
| Child module cannot access parent | Data flows only via **inputs** and **outputs** |
| `terraform get` | Alternative to re-running `init` just to refresh modules |

---

## Module Source Types

```hcl
# Local path
source = "../modules/s3-bucket"

# Public Terraform Registry
source  = "terraform-aws-modules/vpc/aws"
version = "~> 5.0"

# GitHub
source = "github.com/org/repo//modules/s3-bucket"

# S3 bucket
source = "s3::https://s3.amazonaws.com/my-bucket/module.zip"
```

---

## .gitignore

```
.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl
*.tfvars
```

---

## Git Commit

```bash
cd terraform-associate-labs
git add modules/ lab-06-modules/
git commit -m "feat: day-06 reusable s3-bucket module with inputs and outputs"
git push origin main
```

---

## Day 6 Checklist

- [ ] Can explain the difference between root module and child module
- [ ] Know all module source types (local, registry, GitHub, S3)
- [ ] `version` in module block only applies to registry/remote sources
- [ ] `terraform init` re-run required after module source changes
- [ ] Child module outputs accessed via `module.<name>.<output>`
- [ ] State addresses include `module.<name>.` prefix
- [ ] `modules/` folder created and pushed to GitHub
- [ ] `lab-06-modules/` committed with working `init → plan → apply → destroy`

---

*Next → Day 7: Mini VPC + EC2 project combining all Week 1 concepts*
