data "tls_certificate" "oidc" {
  url = var.cluster_oidc_issuer
}