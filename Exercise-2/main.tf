# 1. Configure the AWS Provider for the Backup Account
provider "aws" {
  region = "eu-central-1"
}

# 2. The S3 Bucket Core
resource "aws_s3_bucket" "backups" {
  bucket        = "prod-app-backups-180-day-retention" # Must be globally unique
  force_destroy = false                                # Protects backups from accidental deletion

  tags = {
    Name        = "Application Backups"
    Environment = "Production"
  }
}

# 3. SECURITY: Total Public Access Block
resource "aws_s3_bucket_public_access_block" "backups_privacy" {
  bucket = aws_s3_bucket.backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. SECURITY: Enforce Bucket Ownership
resource "aws_s3_bucket_ownership_controls" "backups_ownership" {
  bucket = aws_s3_bucket.backups.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# 5. SECURITY: Enforce Default AES256 Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "backups_encryption" {
  bucket = aws_s3_bucket.backups.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 6. SECURITY: Enable Versioning
resource "aws_s3_bucket_versioning_configuration" "backups_versioning" {
  bucket = aws_s3_bucket.backups.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 7. COST & RETENTION: 180-Day Lifecycle Wall
resource "aws_s3_bucket_lifecycle_configuration" "backups_lifecycle" {
  bucket = aws_s3_bucket.backups.id

  # Manage active backup files
  rule {
    id     = "backup-lifecycle"
    status = "Enabled"

    # COST SAVING: Move files to Infrequent Access after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # MANDATORY RETENTION: Delete automatically at exactly 180 days
    expiration {
      days = 180
    }
  }

  # Clean up older versions automatically to prevent stealth costs
  rule {
    id     = "clean-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

# 8. CROSS-ACCOUNT SECURITY: Explicit policy allowing the external role to upload data
resource "aws_s3_bucket_policy" "cross_account_upload_policy" {
  bucket = aws_s3_bucket.backups.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowExternalRoleToUpload"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:role/backup_uploader"
        }
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.backups.arn}/*"
      }
    ]
  })
}