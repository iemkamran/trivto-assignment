module "vpc" {
  source = "../../modules/vpc"

  project            = var.project
  environment        = var.environment
  cluster_name       = var.cluster_name
  cidr               = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
}

module "kms" {

  source = "../../modules/kms"

  project = var.project

  environment = var.environment

}

module "iam" {

  source = "../../modules/iam"

  project = var.project

  environment = var.environment

}

module "eks" {

  source = "../../modules/eks"

  cluster_name = var.cluster_name

  cluster_version = "1.31"

  project = var.project

  environment = var.environment

  vpc_id = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnets

  cluster_role_arn = module.iam.cluster_role_arn

  node_role_arn = module.iam.node_role_arn

  kms_key_arn = module.kms.kms_key_arn

}

module "irsa" {
  source = "../../modules/irsa"

  project     = var.project
  environment = var.environment

  cluster_oidc_issuer = module.eks.cluster_oidc_issuer

}


module "addons" {

  source = "../../modules/addons"

  providers = {

    kubernetes = kubernetes

    helm = helm

  }

  cluster_name = module.eks.cluster_name

  vpc_id = module.vpc.vpc_id

  region = var.region

  alb_controller_role_arn = module.irsa.alb_controller_role_arn
  ebs_csi_role_arn        = module.irsa.ebs_csi_role_arn

}

