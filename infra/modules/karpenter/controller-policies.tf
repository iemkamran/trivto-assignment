resource "aws_iam_policy" "node_lifecycle" {
  name        = "${local.prefix}-karpenter-node-lifecycle"
  description = "Karpenter node lifecycle permissions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "KarpenterNodeLifecycle"
        Effect = "Allow"
        Action = [
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:CreateTags",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteLaunchTemplateVersions",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstances",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets",
          "ec2:ModifyInstanceAttribute",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "pricing:GetProducts",
          "ssm:GetParameter"
        ]
        Resource = "*"
      }
    ]
  })
  tags = local.common_tags
}

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

resource "aws_iam_policy" "resource_discovery" {
  name        = "${local.prefix}-karpenter-resource-discovery"
  description = "Karpenter resource discovery permissions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ResourceDiscovery"
        Effect = "Allow"
        Action = [
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets",
          "pricing:GetProducts",
          "ssm:GetParameter"
        ]
        Resource = "*"
      }
    ]
  })
  tags = local.common_tags
}

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
