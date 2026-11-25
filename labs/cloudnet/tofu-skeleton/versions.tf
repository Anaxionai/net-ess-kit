# OpenTofu and the AWS provider. The versions are in the course kit's VERSIONS.md.
terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.74.0"
    }
  }

  # The state file lives in the module folder, three levels up from <task folder>/cloudnet/infra/,
  # so every task folder of the module shares one state. It is never committed.
  backend "local" {
    path = "../../../cloudnet.tfstate"
  }
}
