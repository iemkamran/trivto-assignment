resource "aws_iam_policy" "eks_integration" {
  name        = "${local.prefix}-karpenter-eks-integration"
  description = "Karpenter EKS integration permissions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EKSClusterEndpointLookup"
        Effect = "Allow"
        Action = "eks:DescribeCluster"
        Resource = "arn:${data.aws_partition.current.partition}:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"
      }
    ]
  })
  tags = local.common_tags
}
