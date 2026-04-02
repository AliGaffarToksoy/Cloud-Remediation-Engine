# 1. Terraform Sürüm Kilitleme (Apple Silicon için Stabil v5 sürümü)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0" # v6'daki gRPC hatalarından kaçınmak için stabil sürüme kilitledik
    }
  }
}

# 2. AWS Sağlayıcı Ayarları (LocalStack'e Yönlendirme)
provider "aws" {
  region                      = "eu-central-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Mac IPv6 karmaşasını önlemek için localhost yerine doğrudan 127.0.0.1
  endpoints {
    s3  = "http://127.0.0.1:4566"
    sqs = "http://127.0.0.1:4566"
  }
}

# 3. Zafiyetli (Dışarı Açık) S3 Bucket Yaratımı
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "company-confidential-data"
}

resource "aws_s3_bucket_public_access_block" "vulnerable_bucket_access" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Güvenlik İhlallerinin Düşeceği SQS Kuyruğu
resource "aws_sqs_queue" "security_alerts_queue" {
  name = "security-alerts-queue"
}