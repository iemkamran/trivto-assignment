resource "aws_iam_policy" "alb_controller" {

  name = "${local.prefix}-alb-controller"

  policy = file("${path.module}/policies/aws-load-balancer-controller.json")

  tags = local.common_tags
}

data "aws_iam_policy_document" "alb_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.this.arn
      ]
    }

    condition {
    test     = "StringEquals"
    variable = "${replace(var.cluster_oidc_issuer, "https://", "")}:sub"

    values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
    ]
    }

    condition {
    test     = "StringEquals"
    variable = "${replace(var.cluster_oidc_issuer, "https://", "")}:aud"

    values = [
        "sts.amazonaws.com"
    ]
    }
  }
}

resource "aws_iam_role" "alb_controller" {

  name = "${local.prefix}-alb-controller"

  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "alb_controller" {

  role = aws_iam_role.alb_controller.name

  policy_arn = aws_iam_policy.alb_controller.arn
}