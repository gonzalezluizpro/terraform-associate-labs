terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

resource "local_file" "hello" {
  content  = "Hello, Terraform! I am learning IaC."
  filename = "${path.module}/hello-world.txt"
}

output "file_content" {
  value = resource.local_file.hello.content
}
