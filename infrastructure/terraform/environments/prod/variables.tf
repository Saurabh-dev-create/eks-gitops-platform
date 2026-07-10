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
  default = "prod-cluster"
}

variable "cluster_version" {
  default = "1.34"
}

variable "environment" {
  default = "prod"
}

variable "vpc_name" {
  default = "prod-vpc"
}

variable "vpc_cidr" {
  default = "10.3.0.0/16"
}

variable "capacity_type" {
  default = "ON_DEMAND"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "desired_size" {
  default = 2
}

variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 3
}
variable "private_subnets" {
  default = [
    "10.3.1.0/24",
    "10.3.2.0/24"
  ]
}

variable "public_subnets" {
  default = [
    "10.3.101.0/24",
    "10.3.102.0/24"
  ]
}
