variable "aws_region" {
  default = "ap-south-1"
}
variable "azs" {
  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}
variable "cluster_name" {
  default = "stage-cluster"
}

variable "cluster_version" {
  default = "1.34"
}

variable "environment" {
  default = "stage"
}

variable "vpc_name" {
  default = "stage-vpc"
}

variable "vpc_cidr" {
  default = "10.2.0.0/16"
}

variable "capacity_type" {
  default = "ON_DEMAND"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "desired_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 3
}
variable "private_subnets" {
  default = [
    "10.2.1.0/24",
    "10.2.2.0/24"
  ]
}

variable "public_subnets" {
  default = [
    "10.2.101.0/24",
    "10.2.102.0/24"
  ]
}
