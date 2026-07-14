output "karpenter_node_role_name" {
  value = aws_iam_role.karpenter_node.name
}

output "karpenter_instance_profile_name" {
  value = aws_iam_instance_profile.karpenter.name
}

output "karpenter_release" {
  value = helm_release.karpenter.name
}

output "interruption_queue_name" {
  value = aws_sqs_queue.karpenter.name
}

output "interruption_queue_arn" {
  value = aws_sqs_queue.karpenter.arn
}