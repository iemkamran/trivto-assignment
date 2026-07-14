variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_oidc_issuer" {
  description = "OIDC issuer URL from the EKS cluster"
  type        = string
}
