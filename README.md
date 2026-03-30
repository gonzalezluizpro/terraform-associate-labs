# 🚀 Terraform Associate Labs
[![HCP Terraform](https://img.shields.io/badge/HCP%20Terraform-Connected-7B42BC?logo=terraform)](https://app.terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Provisioned-FF9900?logo=amazonaws)](https://aws.amazon.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> 2-week study plan + hands-on labs for **HashiCorp Certified: Terraform Associate (003)**

This repository documents my journey to mastering Terraform and building a **job-ready Cloud / DevOps portfolio**.

---

# 🎯 Exam Overview

The **Terraform Associate (003)** exam:

- ⏱ Duration: 60 minutes  
- ❓ ~57 questions (multiple choice + true/false)  
- ✅ Passing score: ~70%  
- 📚 Focus areas:
  - Infrastructure as Code (IaC)
  - Terraform CLI workflow (`init → plan → apply → destroy`)
  - Providers & resources
  - Modules
  - State management
  - Workspaces
  - Terraform Cloud (HCP)

---

# 🧠 2-Week Study Plan

## 📅 Week 1 — Core Foundations

Focus: **CLI mastery + HCL fundamentals**

### ✅ Day 1 — IaC & Terraform Basics
- Learn: IaC concepts, Terraform basics, multi-cloud
- Lab: First `main.tf`, run full CLI workflow
- 📁 `lab-01-hello-world/`

---

### ✅ Day 2 — Providers & Resources
- Learn: Providers, version constraints
- Lab: Create AWS resource (S3 or EC2)
- 📁 `lab-02-aws-provider/`

---

### ✅ Day 3 — Variables & Outputs
- Learn: variables, outputs, types (`string`, `map`, `object`)
- Lab: Refactor project with variables
- 📁 update previous lab

---

### ✅ Day 4 — Expressions & Meta-Arguments
- Learn: `for_each`, `count`, `lifecycle`
- Lab: Create multiple resources dynamically
- 📁 `lab-03-meta-arguments/`

---

### ✅ Day 5 — State Management
- Learn: local vs remote state, locking
- Lab: Configure S3 backend + DynamoDB
- 📁 `lab-04-remote-state/`

---

### ✅ Day 6 — Modules
- Learn: reusable modules, inputs/outputs
- Lab: Create `modules/vpc/`
- 📁 `modules/`

---

### 🚀 Day 7 — Mini Project (Capstone)

Build a **real infrastructure project**:

👉 VPC + Subnet + IGW + EC2 + Security Group

📁 `project-01-vpc-infra/`

✔ Uses ALL Week 1 concepts  
✔ Includes README + architecture  
✔ Portfolio-ready  

---

## ⚡ Week 2 — Advanced + Exam Prep

Focus: **real-world usage + passing the exam**

---

### ✅ Day 8 — Dynamic Blocks & Provisioners
- Learn: `dynamic`, `local-exec`, `remote-exec`
- Lab: Dynamic security group rules
- 📁 `lab-05-dynamic-blocks/`

---

### ✅ Day 9 — Workspaces & Import
- Learn: `terraform workspace`, `import`
- Lab: dev / staging / prod environments

---

### ✅ Day 10 — Terraform Cloud (HCP)
- Learn: remote runs, VCS integration
- Lab: Connect GitHub → Terraform Cloud

---

### 🚀 Day 11 — CI/CD Project (IMPORTANT)

Build:

👉 GitHub Actions + Terraform pipeline

- `terraform plan` on PR  
- `terraform apply` on merge  

📁 `project-02-cicd-pipeline/`

💡 This is your **standout portfolio project**

---

### 🧪 Day 12 — Practice Exams
- Take 2 full mock exams  
- Identify weak areas  

---

### 🧪 Day 13 — Weak Areas + Final Practice
- Review mistakes  
- Take 1 more exam (target 80%+)

---

### 🎯 Day 14 — Final Review & Exam
- Review notes + GitHub labs  
- Schedule exam (Pearson VUE)  
- Pass certification 🚀  

---

# 📂 Repository Structure

```

terraform-associate-labs/
├── lab-01-hello-world/
├── lab-02-aws-provider/
├── lab-03-meta-arguments/
├── lab-04-remote-state/
├── lab-05-dynamic-blocks/
├── modules/
│   └── vpc/
├── project-01-vpc-infra/
├── project-02-cicd-pipeline/
└── README.md

````

---

# 🧑‍💻 How to Use

```bash
# Clone repo
git clone https://github.com/<your-username>/terraform-associate-labs.git

# Navigate to project
cd project-01-vpc-infra

# Initialize Terraform
terraform init

# Validate & format
terraform fmt -recursive
terraform validate

# Plan
terraform plan

# Apply
terraform apply
````

---

# 🧠 Key Learnings

* Infrastructure as Code (IaC) in practice
* Clean Terraform structure (modules + environments)
* Remote state with locking (S3 + DynamoDB)
* Dynamic infrastructure using `for_each`
* CI/CD integration with Terraform
* Real-world AWS infrastructure

---

# 🏆 Portfolio Value

This repository demonstrates:

✅ Terraform fundamentals
✅ Real AWS infrastructure deployment
✅ Modular architecture
✅ CI/CD pipeline integration
✅ Production-ready practices

💡 Designed to showcase skills for:

* Cloud Engineer
* DevOps Engineer
* Platform Engineer

---

# 📚 Resources

* [https://developer.hashicorp.com/terraform/tutorials](https://developer.hashicorp.com/terraform/tutorials)
* [https://terraformacademy.app/](https://terraformacademy.app/)
* [https://codingnconcepts.com/post/terraform-associate-exam-questions/](https://codingnconcepts.com/post/terraform-associate-exam-questions/)

---
