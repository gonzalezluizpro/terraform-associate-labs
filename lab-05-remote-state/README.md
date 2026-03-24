# Lab 05 — Remote State with S3 Backend

## What this builds
Demonstrates Terraform remote state management using AWS S3 as the backend
with native S3 locking (Terraform >= 1.10). Shows state migration from local
to remote, all `terraform state` commands, and proves sensitive data is stored
in the state file regardless of `sensitive = true` on outputs.

## Architecture
```text
Phase 1 (bootstrap/)
  local state → creates S3 state bucket (versioned + encrypted + PAB)

Phase 2 (lab-05-remote-state/)
  backend "s3" → tf-state-luiza-lab05-2026/lab-05/terraform.tfstate
       ↓
  app S3 bucket + PAB + secret config object
```

## Key concepts covered
| Concept | Detail |
|---|---|
| Local state | Default — `terraform.tfstate` on disk, no locking |
| Remote state | S3 backend — shared, locked, encrypted, versioned |
| State locking | Native S3 locking (`use_lockfile = true`) — Terraform ≥ 1.10 |
| DynamoDB locking | Deprecated in Terraform 1.10 — still on exam (003) |
| `prevent_destroy` | Applied to state bucket — never accidentally delete it |
| `sensitive = true` | Masks CLI output only — plaintext in state file ⚠️ |

## `terraform state` command reference
| Command | Purpose |
|---|---|
| `terraform state list` | List all tracked resources |
| `terraform state show <addr>` | Show all attributes of one resource |
| `terraform state mv <src> <dst>` | Rename resource without destroy |
| `terraform state rm <addr>` | Remove from state (cloud resource survives) |
| `terraform state pull` | Download remote state as JSON |
| `terraform state push` | Upload local state to remote (use with caution) |
| `terraform force-unlock <ID>` | Release a stuck lock after crash |

## Commands
```bash
cd bootstrap && terraform init && terraform apply   # create state bucket
cd .. && terraform init                             # migrates to S3 backend
terraform validate && terraform fmt
terraform plan && terraform apply
terraform state list
terraform state show aws_s3_bucket.app
terraform state pull | grep -i secret              # observe sensitive data in state
terraform destroy
```

## Security takeaways
- Always enable S3 versioning + encryption on state buckets
- Restrict state bucket access with IAM — treat it like a secrets store
- `sensitive = true` on outputs ≠ protected in state file
- Use SSE-KMS for highest security; SSE-S3 (AES256) is minimum
