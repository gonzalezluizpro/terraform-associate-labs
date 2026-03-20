# Lab 04 — Meta-Arguments: count, for_each, lifecycle, depends_on

## What this builds
Three AWS S3 buckets (dev, staging, prod) created dynamically using
`for_each` on a `map(object)` variable. Demonstrates all four meta-arguments
and key built-in functions in a real multi-environment pattern.

## Architecture
```text
var.buckets (map of objects)
     ↓ for_each
aws_s3_bucket.multi["dev"]      → PAB["dev"]
aws_s3_bucket.multi["staging"]  → PAB["staging"] + versioning["staging"]
aws_s3_bucket.multi["prod"]     → PAB["prod"]    + versioning["prod"]
```

## Meta-arguments used
| Meta-argument | Where | Purpose |
|---|---|---|
| `for_each` | `aws_s3_bucket`, `pab`, `versioning` | One resource per map key |
| `count` | `local_file.env_log` | N identical files by index |
| `depends_on` | `versioning` | Explicit ordering after PAB |
| `lifecycle` | `aws_s3_bucket` | prevent_destroy toggle demo |

## Built-in functions used
| Function | Where | Purpose |
|---|---|---|
| `format()` | locals | Build bucket name strings |
| `lower()` | locals | Normalize owner name |
| `merge()` | locals | Combine common + per-env tags |
| `length()` | outputs, count | Count map entries |
| `values()` | outputs | Extract map values as list |
| `keys()` | count | Get map keys for count |
| `toset()` | (study) | Convert list → set for for_each |
| `lookup()` | (study) | Safe map key access with default |

## count vs for_each — Key difference
Removing `"staging"` from `var.buckets`:
- `for_each`: only `multi["staging"]` is destroyed ✅
- `count`: indexes shift — unrelated resources may be replaced ⚠️

## Commands
```bash
terraform init && terraform validate && terraform fmt
terraform plan
terraform apply
terraform state list     # See for_each key-based addresses
terraform output
terraform destroy
```
