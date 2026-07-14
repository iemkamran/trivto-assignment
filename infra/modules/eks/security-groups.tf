#Cluster Security Group
resource "aws_security_group" "cluster" {

  name        = "${var.cluster_name}-cluster-sg"
  description = "Security Group for EKS Control Plane"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.cluster_name}-cluster-sg"
    }
  )
}

#Node Security Group
resource "aws_security_group" "nodes" {

  name        = "${var.cluster_name}-nodes-sg"
  description = "Security Group for EKS Worker Nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.cluster_name}-nodes-sg"

      "karpenter.sh/discovery" = var.cluster_name
    }
  )
}

#Control Plane -> Node Communication
resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes" {

  security_group_id = aws_security_group.nodes.id

  referenced_security_group_id = aws_security_group.cluster.id

  ip_protocol = "tcp"

  from_port = 443

  to_port = 443

  description = "Control Plane to Worker Nodes"
}

# Node to Cluster
resource "aws_vpc_security_group_ingress_rule" "nodes_to_cluster" {

  security_group_id            = aws_security_group.cluster.id

  referenced_security_group_id = aws_security_group.nodes.id

  ip_protocol = "tcp"

  from_port = 443

  to_port = 443

  description = "Worker Nodes to Control Plane"
}

#Node-to-Node Communication

resource "aws_vpc_security_group_ingress_rule" "node_to_node" {

  security_group_id = aws_security_group.nodes.id

  referenced_security_group_id = aws_security_group.nodes.id

  ip_protocol = "-1"

  description = "Node to Node Communication"
}

#Cluster to Node

resource "aws_vpc_security_group_egress_rule" "cluster_to_nodes" {

  security_group_id = aws_security_group.cluster.id

  referenced_security_group_id = aws_security_group.nodes.id

  ip_protocol = "tcp"

  from_port = 443

  to_port = 443

  description = "Control Plane to Worker Nodes"
}

#Cluster to Kubelet

resource "aws_vpc_security_group_ingress_rule" "cluster_to_kubelet" {

  security_group_id            = aws_security_group.nodes.id

  referenced_security_group_id = aws_security_group.cluster.id

  ip_protocol = "tcp"

  from_port = 10250

  to_port   = 10250

  description = "Control Plane to Kubelet"
}

#Node Internet Access

resource "aws_vpc_security_group_egress_rule" "nodes_internet" {

  security_group_id = aws_security_group.nodes.id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

  description = "Worker node outbound traffic"
}

#Cluster Internet Access

resource "aws_vpc_security_group_egress_rule" "cluster_outbound" {

  security_group_id = aws_security_group.cluster.id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

  description = "Control Plane outbound access"
}

