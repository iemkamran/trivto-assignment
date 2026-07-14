resource "aws_iam_openid_connect_provider" "this" {

  url = var.cluster_oidc_issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.oidc.certificates[0].sha1_fingerprint
  ]

  tags = local.common_tags
}