resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 1. Bucket S3
resource "aws_s3_bucket" "mon_bucket" {
  bucket = "mon-bucket-tf-demo-${random_id.bucket_suffix.hex}"
  force_destroy = true
}
#