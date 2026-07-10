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
  default = "platform-cluster"
}

variable "environment" {
  default = "platform"
}

variable "vpc_name" {
  default = "platform-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
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

variable "cluster_version" {
  default = "1.34"
}
variable "private_subnets" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "public_subnets" {
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
}
