resource "aws_iam_policy" "iam_integration" {
  name        = "${local.prefix}-karpenter-iam-integration"
  description = "Karpenter IAM integration permissions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PassNodeIAMRole"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${local.prefix}-karpenter-node-role"
      }
    ]
  })
  tags = local.common_tags
}
