provider "aws" {
  # profile argument is used by the aws provider to authenticate with aws
  profile = var.profile
  region  = var.region
}
