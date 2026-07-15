resource "aws_iam_policy" "zonal_shift" {
  name        = "${local.prefix}-karpenter-zonal-shift"
  description = "Karpenter zonal shift permissions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowScopedInstanceProfileCreationActions"
        Effect = "Allow"
        Resource = "*"
        Action = ["iam:CreateInstanceProfile"]
        Condition = {
          StringEquals = {
            "aws:RequestTag/kubernetes.io/cluster/" = "owned"
            "aws:RequestTag/topology.kubernetes.io/region" = ""
          }
          StringLike = {
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid    = "AllowScopedInstanceProfileTagActions"
        Effect = "Allow"
        Resource = "*"
        Action = ["iam:TagInstanceProfile"]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region" = ""
            "aws:RequestTag/kubernetes.io/cluster/" = "owned"
            "aws:RequestTag/topology.kubernetes.io/region" = ""
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid    = "AllowScopedInstanceProfileActions"
        Effect = "Allow"
        Resource = "*"
        Action = [
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region" = ""
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid    = "AllowInstanceProfileReadActions"
        Effect = "Allow"
        Resource = "*"
        Action = "iam:GetInstanceProfile"
      }
    ]
  })
  tags = local.common_tags
}
