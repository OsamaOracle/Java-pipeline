terraform {
  cloud {
    organization = "Test"

    workspaces {
      name = "infrastructure"
    }
  }
}