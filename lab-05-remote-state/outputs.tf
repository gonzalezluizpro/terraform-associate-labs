output "backend_config_snippet" {
  description = "Copy this into any module that needs to use this remote backend"
  value = <<-EOT
    backend "s3" {
      bucket       = "tf-state-luiza-lab05-2026"
      key          = "<your-module>/terraform.tfstate"
      region       = "eu-west-1"
      use_lockfile = true
      encrypt      = true
    }
  EOT
}
