
# Terraform backend configuration
terraform {
  backend "s3" {
    bucket         = "terraform-state-xkpk341b"   # Replace with your actual bucket name after creation
    key            = "envs/dev/terraform.tfstate" # key will be created automatically means no need to create the folders envs/dev/
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
