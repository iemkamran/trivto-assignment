variable "cluster_name" {
  type = string
}

variable "alb_controller_role_arn" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string
}

variable "ebs_csi_role_arn" {
  description = "IAM Role ARN for EBS CSI Driver IRSA"
  type        = string
}