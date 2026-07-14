terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">=5.80,<6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }

  }

}