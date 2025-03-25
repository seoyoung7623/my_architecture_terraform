variable "stage" {
  description = "Environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

# S3 Bucket for Terraform backend
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "seoyoung-terraformstate-s3"
  force_destroy = false

  tags = {
    Name        = "terraform-backend-${var.stage}"
    Environment = var.stage
  }
}

# 아직은 버저닝 안씀
# # Enable versioning on the bucket
# resource "aws_s3_bucket_versioning" "enabled" {
#   bucket = aws_s3_bucket.terraform_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# Enable encryption (AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access (good practice)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy (예시: 현재 사용자에게 권한 부여 – 실제 환경에 맞게 수정 가능)
# resource "aws_s3_bucket_policy" "terraform_state_policy" {
#   bucket = aws_s3_bucket.terraform_state.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = "*",
#         Action = [
#           "s3:GetBucketPolicy",
#           "s3:ListBucket",
#           "s3:GetObject",
#           "s3:PutObject"
#         ],
#         Resource = [
#           "arn:aws:s3:::seoyoung-terraformstate-s3",
#           "arn:aws:s3:::seoyoung-terraformstate-s3/*"
#         ]
#       }
#     ]
#   })
# }

# DynamoDB Table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "seoyoung-terraformstate-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-lock-${var.stage}"
    Environment = var.stage
  }
}

# 출력 (옵션)
output "backend_config" {
  value = {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "${var.stage}/terraform/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
  }
}
