# Random string to append to S3 bucket name to ensure uniqueness
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Create S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${random_string.random.result}"

  # Add force_destroy to prevent deletion of bucket and its contents
  force_destroy = false

  # Prevent accidental deletion of this S3 bucket at the terraform level
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning for state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
    #  status = "Suspended"
    #  status = "Disabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name                        = "terraform-state-lock"
  billing_mode                = "PROVISIONED" # Changed from PAY_PER_REQUEST to PROVISIONED
  read_capacity               = 10            # Added for free tier
  write_capacity              = 10            # Added for free tier
  hash_key                    = "LockID"
  deletion_protection_enabled = true

  lifecycle {
    prevent_destroy = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
