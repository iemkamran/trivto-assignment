resource "aws_iam_policy" "karpenter_node_lifecycle" {
  name        = "${local.prefix}-karpenter-node-lifecycle"
  description = "Karpenter node lifecycle actions"
  policy      = templatefile("${path.module}/policies/node-lifecycle.json", {
    partition  = data.aws_partition.current.partition
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
    cluster_name = var.cluster_name
  })
  tags = local.common_tags
}

resource "aws_iam_policy" "karpenter_iam_integration" {
  name        = "${local.prefix}-karpenter-iam-integration"
  description = "Karpenter IAM integration actions"
  policy      = templatefile("${path.module}/policies/iam-integration.json", {
    partition  = data.aws_partition.current.partition
    account_id = data.aws_caller_identity.current.account_id
  })
  tags = local.common_tags
}

resource "aws_iam_policy" "karpenter_eks_integration" {
  name        = "${local.prefix}-karpenter-eks-integration"
  description = "Karpenter EKS integration actions"
  policy      = templatefile("${path.module}/policies/eks-integration.json", {
    partition  = data.aws_partition.current.partition
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
    cluster_name = var.cluster_name
  })
  tags = local.common_tags
}

resource "aws_iam_policy" "karpenter_resource_discovery" {
  name        = "${local.prefix}-karpenter-resource-discovery"
  description = "Karpenter resource discovery actions"
  policy      = templatefile("${path.module}/policies/resource-discovery.json", {
    partition  = data.aws_partition.current.partition
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
  })
  tags = local.common_tags
}

resource "aws_iam_policy" "karpenter_interruption" {
  name        = "${local.prefix}-karpenter-interruption"
  description = "Karpenter interruption handling actions"
  policy      = templatefile("${path.module}/policies/interruption.json", {
    partition  = data.aws_partition.current.partition
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
    cluster_name = var.cluster_name
  })
  tags = local.common_tags
}

resource "aws_iam_policy" "karpenter_zonal_shift" {
  name        = "${local.prefix}-karpenter-zonal-shift"
  description = "Scoped instance profile and tagging actions for zonal shifts"
  policy      = templatefile("${path.module}/policies/zonal-shift.json", {
    partition  = data.aws_partition.current.partition
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
  })
  tags = local.common_tags
}
