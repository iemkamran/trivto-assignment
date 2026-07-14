resource "aws_kms_key" "eks" {

  description             = "KMS key for EKS secrets encryption"

  deletion_window_in_days = 30

  enable_key_rotation     = true

  tags = local.tags
}

resource "aws_kms_alias" "eks" {

  name = "alias/${local.name}-eks"

  target_key_id = aws_kms_key.eks.key_id

}