# AWS in Mumbai, signed in through the cloudnet-tofu profile (see setup/aws.md).
provider "aws" {
  region  = "ap-south-1"
  profile = "cloudnet-tofu"

  # Every resource that takes tags gets project = cloudnet, so one filter finds them all.
  default_tags {
    tags = {
      project = "cloudnet"
    }
  }
}
