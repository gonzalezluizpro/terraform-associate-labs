# Lab 08 — Workspaces & Import

> **HashiCorp Certified: Terraform Associate 003** | Week 2 · Day 9

## What This Lab Builds

Three isolated AWS S3 buckets — one per environment (`dev`, `staging`, `prod`) —
provisioned from a **single codebase** using Terraform workspaces and `.tfvars`
files. Demonstrates how workspace state isolation works and how `terraform import`
brings existing resources under Terraform management.

---

## Architecture

```text
Same main.tf codebase
        │
        ├── workspace: dev     → terraform.tfstate.d/dev/     → s3-bucket-dev
        ├── workspace: staging → terraform.tfstate.d/staging/ → s3-bucket-staging
        └── workspace: prod    → terraform.tfstate.d/prod/    → s3-bucket-prod

Each workspace has its own isolated state — environments never interfere.
```

---

## Folder Structure

```
lab-08-workspaces/
├── main.tf                    ← Uses terraform.workspace variable
├── variables.tf               ← instance_type, bucket_suffix
├── outputs.tf                 ← Active workspace + bucket name
├── environments/
│   ├── dev.tfvars             ← t3.micro, dev bucket config
│   ├── staging.tfvars         ← t3.small, staging bucket config
│   └── prod.tfvars            ← t3.medium, prod bucket config
└── README.md
```

---

## Key Concepts Covered

### What Is a Workspace?

A workspace is an **isolated state file** within the same Terraform configuration.
Every project starts with a `default` workspace. New workspaces each get their own
`terraform.tfstate` so environments never interfere with each other — even though
they share the same `.tf` code.

> Think of workspaces as **Git branches for state** — same code, different state context.

---

### The 5 Workspace Commands (Exam Essential)

| Command | What It Does |
|---|---|
| `terraform workspace list` | List all workspaces (`*` marks the active one) |
| `terraform workspace show` | Print the name of the current active workspace |
| `terraform workspace new dev` | Create AND switch to a new workspace |
| `terraform workspace select prod` | Switch to an existing workspace |
| `terraform workspace delete staging` | Delete a workspace (must have no resources in state) |

---

### `terraform.workspace` Variable

Reference the active workspace name anywhere in your `.tf` files:

```hcl
locals {
  env = terraform.workspace   # returns "dev", "staging", or "prod"
}

resource "aws_s3_bucket" "env_bucket" {
  bucket = "tf-lab-08-${local.env}-${var.bucket_suffix}"

  tags = {
    Name        = "tf-lab-08-${local.env}"
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}
```

---

### Where State Files Are Stored

| Backend | State Location |
|---|---|
| Local (this lab) | `terraform.tfstate.d/<workspace>/terraform.tfstate` |
| S3 remote backend | `s3://bucket/<key>/<workspace>/terraform.tfstate` |
| `default` workspace | Always at root path — no subfolder |

---

### Workspaces vs. Modules (Most Tested Exam Topic)

| Feature | Workspaces | Modules |
|---|---|---|
| Purpose | Separate **state** | Reuse **logic** |
| Code structure | Same code for all envs | Separate folders per env |
| Best for | Identical infra, different config | Different resource sets per env |
| State handling | Auto-isolated per workspace | Each needs its own backend config |
| Safe in CI/CD | ❌ Often problematic | ✅ Preferred for strict isolation |
| Env reference | `terraform.workspace` (implicit) | Explicit via variables |

> **Exam rule:** Use workspaces when infrastructure is **identical across environments**
> but config differs (instance size, naming). Use **separate directories + modules**
> when environments have different resource sets or need strict isolation.

---

## `terraform import` — Bring Existing Resources into State

`terraform import` brings infrastructure created **outside of Terraform** (e.g.
manually in the AWS Console) under Terraform management — without recreating it.

### The 2-Step Process

**Step 1 — Write the resource block first:**

```hcl
# You MUST write this in main.tf before running import
resource "aws_s3_bucket" "existing" {
  bucket = "my-existing-bucket-name"
}
```

**Step 2 — Run the import command:**

```bash
# terraform import <resource_type>.<name> <real-world-id>
terraform import aws_s3_bucket.existing my-existing-bucket-name

# Import a resource inside a module
terraform import module.vpc.aws_vpc.this vpc-0abc123def456
```

**Step 3 — Always run plan after importing:**

```bash
terraform plan   # check for drift between your config and real state
```

### HCL-Native Import Block (Terraform 1.5+)

```hcl
import {
  id = "my-existing-bucket-name"
  to = aws_s3_bucket.existing
}
```

```bash
# Auto-generate the resource block from real infrastructure
terraform plan -generate-config-out=generated.tf
terraform apply
```

### Import Exam Rules

| Rule | Detail |
|---|---|
| Write config first | Resource block must exist before `import` |
| One at a time | Classic CLI imports 1 resource per command |
| Does NOT generate HCL | Only updates state — you write the config manually |
| Always plan after | Check for drift between config and imported state |
| Tainted ≠ imported | Import adds to state; tainted marks for recreation |
| `import {}` block | New native syntax — can auto-generate config (1.5+) |

---

## Commands

```bash
cd lab-08-workspaces

# Initialize
terraform init

# ── DEV ──────────────────────────────────────────────────
terraform workspace new dev
terraform workspace show                        # → dev
terraform plan    -var-file="environments/dev.tfvars"
terraform apply   -var-file="environments/dev.tfvars"
terraform output                                # bucket name + active workspace

# ── STAGING ──────────────────────────────────────────────
terraform workspace new staging
terraform plan    -var-file="environments/staging.tfvars"
terraform apply   -var-file="environments/staging.tfvars"

# ── PROD ─────────────────────────────────────────────────
terraform workspace new prod
terraform plan    -var-file="environments/prod.tfvars"
terraform apply   -var-file="environments/prod.tfvars"

# ── Verify State Isolation ────────────────────────────────
terraform workspace list
# Output:
#   default
#   dev
#   staging
# * prod          ← currently active

terraform workspace select dev
terraform state list   # only dev bucket — staging/prod invisible

# ── Import Demo ──────────────────────────────────────────
# 1. Create a bucket manually in AWS Console
# 2. Add resource block to main.tf
# 3. Import it:
terraform import aws_s3_bucket.existing your-manual-bucket-name
terraform plan   # check for drift

# ── Clean Up ─────────────────────────────────────────────
terraform workspace select dev
terraform destroy -var-file="environments/dev.tfvars"

terraform workspace select staging
terraform destroy -var-file="environments/staging.tfvars"

terraform workspace select prod
terraform destroy -var-file="environments/prod.tfvars"
```

---

## Outputs

| Output | Description |
|---|---|
| `workspace` | Name of the currently active workspace |
| `bucket_name` | Name of the S3 bucket created in this workspace |

---

## .gitignore

```
.terraform/
*.tfstate
*.tfstate.backup
terraform.tfstate.d/
.terraform.lock.hcl
*.tfvars.bak
```

> ⚠️ Do NOT gitignore `environments/*.tfvars` — these are not secrets, they are
> environment config files that belong in version control.

---

## Day 9 Checklist

- [ ] Know all 5 `terraform workspace` commands and what each does
- [ ] `terraform.workspace` variable used in resource names and tags
- [ ] Understand state is stored in `terraform.tfstate.d/<name>/` locally
- [ ] Can explain workspaces vs. modules — when to use each
- [ ] `terraform import` completed — resource block written first
- [ ] `terraform plan` run after import to verify no drift
- [ ] Know the `import {}` block syntax (Terraform 1.5+)
- [ ] All 3 environments committed and pushed to GitHub

---

## Git Commit

```bash
git add lab-08-workspaces/
git commit -m "feat: lab-08 workspaces dev/staging/prod + terraform import demo"
git push origin main
```

---

*Next → Day 10: HCP Terraform (Terraform Cloud) — remote runs, VCS workflows,
variable sets, Sentinel policies, cost estimation*
```