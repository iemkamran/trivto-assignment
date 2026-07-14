output "vpc_id" {

  value = module.vpc.vpc_id

}

output "kms_key" {

  value = module.kms.kms_key_arn

}

output "cluster_role" {

  value = module.iam.cluster_role_arn

}