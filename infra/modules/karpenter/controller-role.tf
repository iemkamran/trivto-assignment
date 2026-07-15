data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}



data "aws_iam_policy_document" "karpenter_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.cluster_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:karpenter"
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.cluster_oidc_issuer, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {

  name = "${local.prefix}-karpenter-controller"

  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "node_lifecycle" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.node_lifecycle.arn
}

resource "aws_iam_role_policy_attachment" "iam_integration" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.iam_integration.arn
}

resource "aws_iam_role_policy_attachment" "eks_integration" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.eks_integration.arn
}

resource "aws_iam_role_policy_attachment" "resource_discovery" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.resource_discovery.arn
}

resource "aws_iam_role_policy_attachment" "interruption" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.interruption.arn
}

resource "aws_iam_role_policy_attachment" "zonal_shift" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.zonal_shift.arn
}