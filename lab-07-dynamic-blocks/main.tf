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
  tags       = { Name = "lab-08-vpc" }
}

resource "aws_security_group" "dynamic_sg" {
  name        = "lab-08-dynamic-sg"
  description = "Security group built with dynamic blocks"
  vpc_id      = aws_vpc.lab.id

  # Dynamic block replaces N hardcoded ingress {} blocks
  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    iterator = rule # optional: rename loop variable
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

  tags = { Name = "lab-07-dynamic-sg", ManagedBy = "Terraform" }
}