# Project 02 — CI/CD Pipeline with GitHub Actions

> **HashiCorp Certified: Terraform Associate 003** | Week 2 · Day 11
> 🏆 Standout Portfolio Piece

## What This Project Builds

A production-style **GitHub Actions CI/CD pipeline** that automates the full
Terraform workflow:
- `terraform plan` runs automatically on every **Pull Request**
- Plan output is posted as a **PR comment** for team review
- `terraform apply` runs automatically on **merge to main**
- AWS credentials are stored securely as **GitHub Secrets**
- State is managed remotely via **HCP Terraform**

---

## Pipeline Architecture
```text
PR opened/updated
│
▼
[terraform-plan.yml]
checkout → setup-terraform → aws-credentials
→ init → fmt --check → validate → plan
→ post plan as PR comment
│
▼
Team reviews plan in PR comment
│
▼
PR merged to main
│
▼
[terraform-apply.yml]
checkout → setup-terraform → aws-credentials
→ init → apply -auto-approve
│
▼
Infrastructure deployed ✅

```

---

## Folder Structure
```text
terraform-associate-labs/
├── .github/
│   └── workflows/
│       ├── terraform-plan.yml
│       └── terraform-apply.yml
└── project-02-cicd-pipeline/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── backend.tf
    └── README.md

```

---

## GitHub Secrets Required

Go to: **Settings → Secrets and variables → Actions → New repository secret**

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `TF_API_TOKEN` | HCP Terraform API token — required for remote backend auth |

> Never hardcode credentials — always use `${{ secrets.NAME }}` in workflows.

---

## HCP Terraform Workspace Variables

The plan runs **remotely on HCP Terraform workers** — AWS credentials must
also be configured inside the workspace, not just as GitHub Secrets.

Go to: `app.terraform.io` → Organization → Workspace `project-02-cicd-pipeline`
→ **Variables → + Add variable**

| Variable | Type | Sensitive |
|---|---|---|
| `AWS_ACCESS_KEY_ID` | Environment Variable | ✅ Yes |
| `AWS_SECRET_ACCESS_KEY` | Environment Variable | ✅ Yes |

> ⚠️ Must be **Environment Variable** type — not Terraform Variable.
> The AWS provider reads environment variables, not tfvars.

---

## Workflow Triggers

| Workflow | Trigger | Action |
|---|---|---|
| `terraform-plan.yml` | PR targeting `main` | Runs plan, posts PR comment |
| `terraform-apply.yml` | Push to `main` (merge) | Runs apply automatically |

## ⚠️ Workflow File Location (Important)

GitHub Actions **only recognizes workflows in `.github/workflows/` at the
repository root** — not inside project subfolders.

Use `paths:` filter in the workflow to scope it to the project folder:
```yaml
on:
  pull_request:
    paths:
      - "project-02-cicd-pipeline/**"
```

---

## Terraform Destroy

Destroy is always run **locally** — never automated in CI/CD pipelines.

```bash
cd project-02-cicd-pipeline

terraform plan -destroy    # preview what will be deleted
terraform destroy          # type: yes to confirm
```

Verify destruction:
```bash
aws s3 ls | findstr "tf-cicd-demo"
# no output = bucket deleted ✅
```

> **Rule:** `terraform apply` can be automated. `terraform destroy` never should be.
> Destroying infrastructure must always require explicit human approval.

---

## Key CI/CD Concepts

| Concept | Detail |
|---|---|
| `-auto-approve` | Skips yes/no prompt — required in automated pipelines |
| `-no-color` | Removes ANSI codes for clean logs |
| `continue-on-error: true` | Posts plan comment even if plan fails |
| `paths:` filter | Only runs when files in this folder change |
| `hashicorp/setup-terraform` | Official action to install Terraform CLI |
| Remote state | Required — GitHub Actions runners are stateless |

---

## Why Remote State Is Required in CI/CD

GitHub Actions runners are **ephemeral** — a fresh VM spins up for every run
and is destroyed after. There is no local `terraform.tfstate` between runs.
Remote state (HCP Terraform or S3) is the only option that works.

---

## How to Test the Pipeline

```bash
# 1. Create a feature branch
git checkout -b feat/test-pipeline

# 2. Make a small change (e.g. add a tag)
# Edit main.tf → add tag: Tested = "true"

# 3. Push and open a PR
git add .
git commit -m "test: trigger CI pipeline plan"
git push origin feat/test-pipeline
# Go to GitHub → open a Pull Request

# 4. Watch the plan run in GitHub Actions tab
# Check the PR comment with the plan output

# 5. Merge the PR
# Watch terraform apply run automatically
```

---

## Day 11 Checklist

- [x] `.github/workflows/` at repo root (not inside project subfolder)
- [x] `terraform-plan.yml` triggers on PR to main
- [x] `terraform-apply.yml` triggers on push to main
- [x] `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` added as GitHub Secrets
- [x] `TF_API_TOKEN` added as GitHub Secret for HCP Terraform auth
- [x] AWS credentials added as Environment Variables in HCP Terraform workspace
- [x] `variables.tf` and `outputs.tf` fully declared
- [x] Plan output posts as a PR comment automatically
- [x] `terraform fmt -check` fails the PR if code is not formatted
- [x] `terraform apply -auto-approve` runs on merge without manual input
- [x] HCP Terraform remote state configured
- [x] Feature branch PR tested end-to-end ✅
- [x] `aws s3 ls` confirmed bucket created via pipeline ✅
- [x] `terraform destroy` completed locally ✅

---

## Git Commit

```bash
git add project-02-cicd-pipeline/
git commit -m "docs: update project-02 README with real implementation learnings"
git push origin main
```

---

*Next → Day 12: Practice Exam Day 1 — 2 full mock exams on codingnconcepts.com*