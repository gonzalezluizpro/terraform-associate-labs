# Project 01 — VPC + EC2 Infrastructure

> **HashiCorp Certified: Terraform Associate 003** | Week 1 · Day 7 Capstone

Week 1 capstone project combining all core Terraform concepts into a single  
real-world AWS infrastructure deployment: a custom VPC with a public subnet,  
security group, and an EC2 web server running Apache.

---

## Architecture

```

Internet
│
▼
Internet Gateway
│
▼
VPC (10.0.0.0/16)
│
└── Public Subnet (10.0.1.0/24) ── eu-west-1a
│
├── Route Table ──► IGW (0.0.0.0/0)
│
└── EC2 Instance (t3.micro) ← Amazon Linux 2023
│
└── Security Group
├── Inbound: 22/tcp (SSH)
└── Inbound: 80/tcp (HTTP)

```

---

## Resources Created

| Resource                         | Type            | Description                                              |
|----------------------------------|-----------------|----------------------------------------------------------|
| `module.vpc`                     | Module          | VPC, Subnet, IGW, Route Table                            |
| `aws_security_group.ec2_sg`      | Security Group  | SSH + HTTP inbound rules via `for_each`                  |
| `aws_instance.web`               | EC2             | Amazon Linux 2023, Apache via `user_data`                |
| `data.aws_ami.amazon_linux`      | Data Source     | Latest Amazon Linux 2023 AMI (dynamic lookup)            |

---

## Week 1 Concepts Applied

| Day   | Concept                                   | Where Used                                                  |
|-------|-------------------------------------------|-------------------------------------------------------------|
| Day 1 | Core CLI workflow                         | `init → validate → fmt → plan → apply → destroy`            |
| Day 2 | AWS Provider + `required_providers`       | `terraform {}` block with `~> 5.0`                          |
| Day 3 | Variables, outputs, type constraints      | `variables.tf`, `outputs.tf`                                |
| Day 4 | `for_each`, `lifecycle`, `format()`       | SG rules via `for_each`; EC2 `lifecycle` block              |
| Day 5 | Remote state                             | S3 backend + DynamoDB lock in `backend.tf`                  |
| Day 6 | Reusable module                          | VPC networking via `module "vpc"`                           |

---

## Folder Structure

```

project-01-vpc-infra/
├── backend.tf      # S3 remote state + DynamoDB lock
├── main.tf         # Provider, module call, SG, EC2
├── variables.tf    # Input variables
├── outputs.tf      # Outputs (VPC, subnet, EC2 info)
└── README.md

````

---

## Prerequisites

- AWS CLI configured (`aws configure`)
- S3 bucket for remote state created
- DynamoDB table `terraform-state-lock` created (PAY_PER_REQUEST)
- Terraform >= 1.9 installed

---

## Commands

```bash
# Initialize — downloads provider, module, and connects to backend
terraform init

# Format files
terraform fmt -recursive

# Validate syntax
terraform validate

# Preview execution (expect ~8 resources)
terraform plan

# Deploy infrastructure
terraform apply

# Test web server (PowerShell)
Invoke-WebRequest -Uri (terraform output -raw web_url) -UseBasicParsing

# Test port 80
Test-NetConnection -ComputerName (terraform output -raw ec2_public_ip) -Port 80

# Inspect state
terraform state list

# Destroy resources (IMPORTANT to avoid costs)
terraform destroy
````

---

## Expected `terraform state list`

```
data.aws_ami.amazon_linux
aws_instance.web
aws_security_group.ec2_sg
module.vpc.aws_internet_gateway.this
module.vpc.aws_route_table.public
module.vpc.aws_route_table_association.public
module.vpc.aws_subnet.public
module.vpc.aws_vpc.this
```

---

## Outputs

| Output             | Description                          |
| ------------------ | ------------------------------------ |
| `vpc_id`           | VPC ID                               |
| `public_subnet_id` | Public Subnet ID                     |
| `ec2_public_ip`    | Public IP of EC2                     |
| `ec2_public_dns`   | Public DNS of EC2                    |
| `web_url`          | HTTP URL to access Apache web server |

---

## Key Exam Takeaways

* Data sources fetch **read-only values** from AWS — AMI is dynamically resolved (no hardcoding).
* `module.<name>.<output>` is how root modules consume outputs.
* `for_each` with `map(object(...))` is safer than `count`.
* `lifecycle { create_before_destroy = true }` avoids downtime.
* State addresses for modules include `module.<name>.`.
* DynamoDB locking is **free-tier friendly** with `PAY_PER_REQUEST`.

---

## Git Commit

```bash
git add modules/vpc/ project-01-vpc-infra/
git commit -m "feat: project-01 mini VPC + EC2 - Week 1 capstone"
git push origin main
```

---

## Next Step

➡️ Day 8: Dynamic blocks, provisioners, `local-exec` / `remote-exec`
