provider "aws" {

  region = var.region

}

#Create the S3 bucket

resource "aws_s3_bucket" "terraform_state" {

  bucket = var.bucket_name

  force_destroy = false

}

#Enable versioning

resource "aws_s3_bucket_versioning" "state" {

  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {

    status = "Enabled"

  }

}

#Server-side encryption

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

#Public access block

resource "aws_s3_bucket_public_access_block" "this" {

  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true

  block_public_policy     = true

  ignore_public_acls      = true

  restrict_public_buckets = true

}