resource "aws_iam_instance_profile" "karpenter" {

  name = "${local.prefix}-karpenter-instance-profile"

  role = aws_iam_role.karpenter_node.name

  tags = local.common_tags
}