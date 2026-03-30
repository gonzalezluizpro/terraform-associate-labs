terraform {
  cloud {
    organization = "lux-it-solutions"

    workspaces {
      name = "terraform-associate-labs"
    }
  }
}