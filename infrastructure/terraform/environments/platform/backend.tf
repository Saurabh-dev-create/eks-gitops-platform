terraform {

  backend "s3" {

    bucket = "saurabh-eks-gitops-terraform-state"

    key = "platform/terraform.tfstate"

    region = "ap-south-1"

    dynamodb_table = "terraform-state-lock"

    encrypt = true

  }

}
