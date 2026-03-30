# Lab 09 — HCP Terraform (Terraform Cloud)

> **HashiCorp Certified: Terraform Associate 003** | Week 2 · Day 10

## What This Lab Demonstrates

Connecting a GitHub repository to HCP Terraform for a fully **VCS-driven workflow**
where every `git push` triggers an automatic `terraform plan` and team-approved
`terraform apply` — with state stored remotely and AWS credentials managed via
variable sets.

---

## Architecture

```text
GitHub Push
│
▼ (webhook)
HCP Terraform detects change
│
▼
terraform plan (runs on HCP worker)
│
▼
Cost Estimation (Team tier)
│
▼
Sentinel Policy Check
│
▼
Manual Approval → terraform apply
│
▼
State saved in HCP Terraform (encrypted)

```

---

## Setup Steps

### 1. Create HCP Terraform Account

- Go to `app.terraform.io` → sign up free
- Create an Organization (e.g. `yourname-terraform-labs`)

### 2. Create a VCS-Driven Workspace

- New Workspace → **Version Control Workflow**
- Connect GitHub → select `terraform-associate-labs` repo
- Set Working Directory to your lab folder
- Click **Create Workspace**

### 3. Add AWS Credentials as Variable Set

- Organization Settings → Variable Sets → Create
- Add Environment Variables (mark sensitive):

| Variable | Type | Sensitive |
|---|---|---|
| `AWS_ACCESS_KEY_ID` | Environment | ✅ Yes |
| `AWS_SECRET_ACCESS_KEY` | Environment | ✅ Yes |

- Apply to your workspace

### 4. Configure `backend.tf`

```hcl
terraform {
  cloud {
    organization = "yourname-terraform-labs"

    workspaces {
      name = "lab-09-hcp-terraform"
    }
  }
}
```

### 5. Authenticate and Initialize

```powershell
terraform login     # opens browser → paste API token
terraform init      # migrates state to HCP Terraform
```

---

## Triggering a VCS-Driven Run

```bash
# Any push to main branch triggers an automatic plan
git add .
git commit -m "test: trigger HCP Terraform VCS-driven run"
git push origin main

# Go to app.terraform.io → workspace → watch the plan
# Click "Confirm & Apply" to apply
```

---

## Key Concepts

### Remote Execution Modes

| Mode | Plan/Apply Runs On | State Stored In |
|---|---|---|
| `remote` (default) | HCP Terraform worker | HCP Terraform |
| `agent` | Your self-hosted agent | HCP Terraform |
| `local` | Your machine | HCP Terraform |

### Variable Sets vs Workspace Variables

| Type | Scope | Use Case |
|---|---|---|
| Variable Set | Multiple workspaces | Shared credentials, org-wide tags |
| Workspace Variable | Single workspace | Env-specific values (region, size) |

### Sentinel Enforcement Levels

| Level | Behavior |
|---|---|
| `advisory` | Warning only — apply proceeds |
| `soft-mandatory` | Blocked — admin can override |
| `hard-mandatory` | Always blocked — no override |

---

## HCP Terraform Exam Cheat Sheet

| Fact | Detail |
|---|---|
| Free tier limit | 500 managed resources, 1 concurrent run |
| Token location | `~/.terraform.d/credentials.tfrc.json` |
| `terraform login` | Authenticates to HCP Terraform |
| `terraform logout` | Removes stored token |
| `cloud` block | Preferred over `remote` backend |
| Speculative plan | Read-only plan on a PR — never applies |
| Private Registry | Host private modules/providers in your org |
| Run triggers | Workspace A triggers Workspace B after apply |
| Cost estimation | Between plan and Sentinel check (Team tier+) |
| State encryption | Always encrypted at rest and in transit |

---

## Day 10 Checklist

- [ ] HCP Terraform account + organization created
- [ ] GitHub repo connected via VCS workflow
- [ ] AWS credentials added as sensitive variable set
- [ ] `cloud {}` block configured in `backend.tf`
- [ ] `terraform login` + `terraform init` completed
- [ ] Git push triggers automatic plan in HCP Terraform UI
- [ ] Manual approval → apply completes successfully
- [ ] Know all 3 Sentinel enforcement levels
- [ ] Know difference between variable sets and workspace variables
- [ ] Know the 3 remote execution modes

---

## Git Commit

```bash
git add lab-09-hcp-terraform/
git commit -m "feat: lab-09 HCP Terraform VCS-driven workflow + variable sets"
git push origin main
```

---

*Next → Day 11: CI/CD pipeline with GitHub Actions — `terraform plan` on PR,
`terraform apply` on merge*