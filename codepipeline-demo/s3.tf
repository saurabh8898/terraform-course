#
# cache s3 bucket
#
resource "aws_s3_bucket" "codebuild-cache" {
  bucket = "demo-codebuild-cache-${random_string.random.result}"
}


resource "aws_s3_bucket" "codebuild-cache_log_bucket" {
  bucket = "codebuild-cache-log-bucket"
}

resource "aws_s3_bucket_logging" "codebuild-cache" {
  bucket = aws_s3_bucket.codebuild-cache.id

  target_bucket = aws_s3_bucket.codebuild-cache_log_bucket.id
  target_prefix = "log/"
}


resource "aws_s3_bucket_versioning" "codebuild-cache" {
  bucket = aws_s3_bucket.codebuild-cache.id

  versioning_configuration {
    status = "Enabled"
  }
}



resource "aws_s3_bucket" "demo-artifacts" {
  bucket = "demo-artifacts-${random_string.random.result}"
  
  # lifecycle moved to aws_s3_bucket_lifecycle_configuration (Change starting from AWS Provider 4.x)
}

resource "aws_s3_bucket_lifecycle_configuration" "demo-artifacts-lifecycle" {
  bucket = aws_s3_bucket.demo-artifacts.id

  rule {
    id     = "clean-up"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}


resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}