variable "aws_region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "saurabh-eks-gitops-terraform-state"
}

variable "dynamodb_table" {
  default = "terraform-state-lock"
}
