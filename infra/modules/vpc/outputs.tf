output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "vpce_security_group" {
  value = aws_security_group.vpce.id
}

output "flowlog_group" {
  value = aws_cloudwatch_log_group.flowlogs.name
}