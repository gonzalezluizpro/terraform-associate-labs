# Lab 07 - Dynamic Blocks & Provisioners 
This lab is part of a **2-week Terraform Associate (003) study plan**.

Day 8 marks the transition into **advanced Terraform concepts**, focusing on:
- Dynamic Blocks (DRY principle in HCL)
- Provisioners (Terraform escape hatch)

---

## 📚 Objectives

By completing this lab, you will:

- Use **dynamic blocks** to generate nested configurations
- Avoid repetitive HCL code (DRY principle)
- Understand and apply **provisioners**
- Learn when (and when NOT) to use provisioners
- Practice real-world infrastructure patterns

---

## 🧱 Project Structure

```text

lab-07-dynamic-blocks/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md

````

---

## ⚙️ Part 1 — Dynamic Blocks

### 🔍 Problem

Without dynamic blocks, you must manually define multiple repeated blocks:

```hcl
ingress { ... }
ingress { ... }
ingress { ... }
````

This becomes hard to maintain.

---

### ✅ Solution: Dynamic Blocks

Dynamic blocks allow you to generate nested blocks using loops.

### Example

```hcl
dynamic "ingress" {
  for_each = var.sg_ingress_rules
  iterator = rule

  content {
    description = rule.value.description
    from_port   = rule.value.port
    to_port     = rule.value.port
    protocol    = rule.value.protocol
    cidr_blocks = [rule.value.cidr]
  }
}
```

---

### 📦 Variables (`variables.tf`)

```hcl
variable "sg_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description = string
    port        = number
    protocol    = string
    cidr        = string
  }))

  default = [
    {
      description = "SSH"
      port        = 22
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "HTTP"
      port        = 80
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "HTTPS"
      port        = 443
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    }
  ]
}
```

---

### 🌐 Infrastructure (`main.tf`)

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

resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab-08-vpc"
  }
}

resource "aws_security_group" "dynamic_sg" {
  name        = "lab-08-dynamic-sg"
  description = "Dynamic SG using Terraform"
  vpc_id      = aws_vpc.lab.id

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    iterator = rule

    content {
      description = rule.value.description
      from_port   = rule.value.port
      to_port     = rule.value.port
      protocol    = rule.value.protocol
      cidr_blocks = [rule.value.cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "lab-08-dynamic-sg"
    ManagedBy = "Terraform"
  }
}
```

---

### 📤 Outputs (`outputs.tf`)

```hcl
output "security_group_id" {
  value = aws_security_group.dynamic_sg.id
}

output "ingress_rule_count" {
  value = length(var.sg_ingress_rules)
}
```

---

## ⚡ Part 2 — Provisioners

Provisioners allow you to run scripts **outside Terraform's declarative model**.

⚠️ Use only when necessary.

---

### 🧩 Types of Provisioners

| Type        | Runs On       | Use Case                     |
| ----------- | ------------- | ---------------------------- |
| local-exec  | Local machine | Logging, scripts, automation |
| remote-exec | Remote host   | Install software via SSH     |
| file        | Remote host   | Copy files                   |

---

### 💻 Example — local-exec

```hcl
provisioner "local-exec" {
  command = "echo Instance created >> deployed.txt"
}
```

---

### 🌍 Example — remote-exec

```hcl
connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = file("~/.ssh/id_rsa")
  host        = self.public_ip
}

provisioner "remote-exec" {
  inline = [
    "sudo yum update -y",
    "sudo yum install -y httpd"
  ]
}
```

---

### 📁 Example — file

```hcl
provisioner "file" {
  source      = "scripts/setup.sh"
  destination = "/tmp/setup.sh"
}
```

---

## ⚠️ Key Rules (Exam Focus)

* Provisioners run at **create time by default**
* `when = destroy` → run on destroy
* Failure → resource becomes **tainted**
* `on_failure = continue` → ignore errors
* Avoid provisioners if possible

---

## 🔁 null_resource Pattern

```hcl
resource "null_resource" "run_script" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo Running script"
  }
}
```

---

## 🧪 CLI Workflow

```bash
terraform init
terraform fmt
terraform validate

terraform plan
terraform apply

terraform state show aws_security_group.dynamic_sg

terraform destroy
```

---

## 📌 Expected Behavior

* 1 VPC created
* 1 Security Group created
* 3 ingress rules dynamically generated
* Adding a new rule → only 1 change in plan

---

## ✅ Checklist

* [ ] Understand dynamic blocks (DRY principle)
* [ ] Know `for_each`, `iterator`, `content`
* [ ] Know where dynamic blocks are supported
* [ ] Understand provisioner types
* [ ] Know taint behavior
* [ ] Know `null_resource` / `terraform_data`

---

## 🧠 Key Takeaways

* Dynamic blocks = **clean, scalable Terraform code**
* Provisioners = **last resort**
* Terraform = **declarative first, imperative only when needed**

---

## 🔜 Next Step

➡️ **Day 9 — Workspaces, `terraform import`, and multi-environment management**

---

## 📝 Commit Example

```bash
git add lab-07-dynamic-blocks/
git commit -m "feat: dynamic blocks + provisioners lab"
git push origin main
```