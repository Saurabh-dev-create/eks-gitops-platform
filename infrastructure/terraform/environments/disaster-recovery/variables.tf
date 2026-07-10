variable "aws_region" {
  default = "ap-southeast-1"
}
variable "azs" {
  default = [
    "ap-southeast-1a",
    "ap-southeast-1b"
  ]
}
variable "cluster_name" {
  default = "dr-cluster"
}

variable "cluster_version" {
  default = "1.34"
}

variable "environment" {
  default = "dr"
}

variable "vpc_name" {
  default = "dr-vpc"
}

variable "vpc_cidr" {
  default = "10.4.0.0/16"
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
    "10.4.1.0/24",
    "10.4.2.0/24"
  ]
}

variable "public_subnets" {
  default = [
    "10.4.101.0/24",
    "10.4.102.0/24"
  ]
}
