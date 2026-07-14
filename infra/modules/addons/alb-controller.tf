resource "kubernetes_service_account" "alb" {

  metadata {

    name = "aws-load-balancer-controller"

    namespace = "kube-system"

    annotations = {

      "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn

    }

  }
}


resource "helm_release" "aws_load_balancer_controller" {

  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"

  chart = "aws-load-balancer-controller"

  namespace = "kube-system"
  
  version = "1.13.4"

  create_namespace = false

  set {
    name = "clusterName"
    value = var.cluster_name
  }
  
  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name = "region"
    value = var.region
  }

  set {
    name  = "replicaCount"
    value = "1"
  }

  set {
    name = "vpcId"
    value = var.vpc_id
  }

  set {
    name = "serviceAccount.create"
    value = "false"
  }

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  depends_on = [
  kubernetes_service_account.alb
]
}


