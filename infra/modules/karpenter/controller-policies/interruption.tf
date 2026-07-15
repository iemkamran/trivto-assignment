resource "aws_iam_policy" "interruption" {
  name        = "${local.prefix}-karpenter-interruption"
  description = "Karpenter interruption permissions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CreateServiceLinkedRoleForEC2Spot"
        Effect = "Allow"
        Action = "iam:CreateServiceLinkedRole"
        Resource = "arn:${data.aws_partition.current.partition}:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot"
      }
    ]
  })
  tags = local.common_tags
}
