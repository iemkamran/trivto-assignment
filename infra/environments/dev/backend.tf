terraform {

  backend "s3" {

    bucket = "kamran-devops-tfstate"

    key = "dev/terraform.tfstate"

    region = "ap-south-1"

    encrypt = true

    use_lockfile = true

  }

}