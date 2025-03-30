resource "aws_s3_bucket" "frontend" {
  bucket = var.frontend_bucket
  force_destroy = true # 이 버킷이 삭제될 때 버킷이 비어있지 않아도 삭제하도록 함

  tags = merge(tomap({
    Name = "s3-frontend-${var.stage}-${var.servicename}" }),
    var.tags
  )
}

resource "aws_s3_bucket_website_configuration" "front_website" {
  bucket = aws_s3_bucket.frontend.bucket
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }  
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "front_policy" {
  bucket = aws_s3_bucket.frontend.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "PublicReadGetObject",
        Effect = "Allow",
        Principal = "*",
        Action = ["s3:GetObject"],
        Resource = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.allow_public ]
}
