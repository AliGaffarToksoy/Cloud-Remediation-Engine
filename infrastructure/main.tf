# 1. AWS Sağlayıcı Ayarları (LocalStack'e Yönlendirme)
provider "aws" {
  region                      = "eu-central-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Bütün AWS isteklerini Amazon yerine bizim LocalStack'e yönlendiriyoruz
  endpoints {
    s3  = "http://localhost:4566"
    sqs = "http://localhost:4566"
  }
}

# 2. Zafiyetli (Dışarı Açık) S3 Bucket Yaratımı
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "company-confidential-data"
}

# Bilerek Public (Dışarıya Açık) bırakıyoruz ki AI Motorumuz bunu yakalayıp kapatsın!
resource "aws_s3_bucket_public_access_block" "vulnerable_bucket_access" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3. Güvenlik İhlallerinin Düşeceği SQS Kuyruğu
resource "aws_sqs_queue" "security_alerts_queue" {
  name = "security-alerts-queue"
}