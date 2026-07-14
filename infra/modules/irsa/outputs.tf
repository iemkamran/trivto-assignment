output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller.arn
}

output "ebs_csi_role_arn" {
  description = "IAM Role ARN for EBS CSI Driver"

  value = aws_iam_role.ebs_csi.arn
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN"

  value = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  description = "OIDC Provider URL"

  value = aws_iam_openid_connect_provider.this.url
}