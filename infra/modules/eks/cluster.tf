resource "aws_eks_cluster" "this" {

  name = var.cluster_name

  version = var.cluster_version

  role_arn = var.cluster_role_arn

  enabled_cluster_log_types = [

    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"

  ]

  access_config {

    authentication_mode = "API_AND_CONFIG_MAP"

    bootstrap_cluster_creator_admin_permissions = true

  }

  vpc_config {

    subnet_ids = var.private_subnets

    security_group_ids = [
    
        aws_security_group.cluster.id,
        aws_security_group.nodes.id

       ]


    endpoint_private_access = var.endpoint_private_access

    endpoint_public_access = var.endpoint_public_access

  }

  kubernetes_network_config {

    ip_family = "ipv4"

  }

  encryption_config {

    provider {

      key_arn = var.kms_key_arn

    }

    resources = [

      "secrets"

    ]

  }

  tags = merge(

    local.common_tags,

    {

      Name = var.cluster_name

    }

  )

  depends_on = [

    aws_cloudwatch_log_group.eks

  ]

}