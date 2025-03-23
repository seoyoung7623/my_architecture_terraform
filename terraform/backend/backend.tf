# S3 버킷 생성
resource "aws_s3_bucket" "terraform_state" { 
  bucket = var.s3_bucket_name
  force_destroy = false # 버킷이 삭제될때 내부에 객체가 남아있으면 삭제 방지
}

# S3 버킷 관리 활성화
resource "aws_s3_bucket_versioning" "enabled" { 
  bucket = aws_s3_bucket.terraform_state.id 
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 서버 사이드 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "default" { 
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 퍼블릭 액세스 차단 해제 -> 퍼블릭 액세스 허용
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 버킷에 대한 버킷 정책 설정
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.terraform_state.arn}/*"
      }
    ]
  })
}

# DynamoDB 테이블 생성
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.dynamoDB_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}