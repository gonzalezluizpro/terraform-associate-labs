# Module: vpc

Reusable Terraform module that provisions a complete AWS VPC networking stack  
with a public subnet, Internet Gateway, and route table.

---

## Resources Created

| Resource                              | Type              | Description                                      |
|--------------------------------------|-------------------|--------------------------------------------------|
| `aws_vpc.this`                       | VPC               | Main VPC with DNS hostnames enabled              |
| `aws_subnet.public`                  | Subnet            | Public subnet with auto-assign public IP         |
| `aws_internet_gateway.this`          | IGW               | Internet Gateway attached to VPC                 |
| `aws_route_table.public`             | Route Table       | Routes `0.0.0.0/0` to IGW                        |
| `aws_route_table_association.public` | Association       | Links public subnet to route table               |

---

## Usage

```hcl
module "vpc" {
  source             = "../modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone  = "eu-west-1a"
  project_name       = "my-project"
}
````

---

## Inputs

| Name                 | Type   | Default       | Description                                            |
| -------------------- | ------ | ------------- | ------------------------------------------------------ |
| `vpc_cidr`           | string | `10.0.0.0/16` | CIDR block for the VPC                                 |
| `public_subnet_cidr` | string | `10.0.1.0/24` | CIDR block for the public subnet                       |
| `availability_zone`  | string | `eu-west-1a`  | AZ to deploy the public subnet                         |
| `project_name`       | string | —             | Project name used in resource Name tags (**required**) |

---

## Outputs

| Name               | Description                 |
| ------------------ | --------------------------- |
| `vpc_id`           | The ID of the created VPC   |
| `public_subnet_id` | The ID of the public subnet |

---

## Accessing Outputs from Root Module

```hcl
module.vpc.vpc_id
module.vpc.public_subnet_id
```

---

## Notes

* `map_public_ip_on_launch = true` is set on the public subnet — EC2 instances launched here automatically receive a public IP.
* This module does **not** create private subnets or a NAT Gateway — extend it in future projects.
* `version` argument is not supported for local path modules (only registry sources).