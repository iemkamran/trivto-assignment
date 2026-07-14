resource "aws_eks_node_group" "default" {

  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${var.cluster_name}-default"

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnets

  ami_type = "AL2023_x86_64_STANDARD"

  capacity_type = "ON_DEMAND"

  launch_template {

    id = aws_launch_template.eks.id

    version = aws_launch_template.eks.latest_version

  }

  scaling_config {

    desired_size = var.desired_size

    min_size = var.min_size

    max_size = var.max_size

  }

  update_config {

    max_unavailable = 1

  }

  labels = {

    workload = "general"

  }

  tags = merge(

    local.common_tags,

    {

      Name = "${var.cluster_name}-nodegroup"

    }

  )

  depends_on = [

    aws_eks_cluster.this,
    aws_cloudwatch_log_group.eks

  ]

}