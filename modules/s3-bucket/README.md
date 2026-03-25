# Lab 06 — Terraform Modules

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

