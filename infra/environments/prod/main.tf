resource "aws_s3_bucket" "example" {
  bucket = "${var.environment}-example-bucket"

  tags = merge(local.tags, {
    Name = "${var.environment}-example-bucket"
  })
}
