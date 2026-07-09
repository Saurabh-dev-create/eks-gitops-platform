variable "aws_region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "enterprise-platform"
}

variable "cluster_version" {
  default = "1.34"
}

variable "vpc_name" {
  default = "enterprise-platform-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
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
variable "capacity_type" {
  default = "ON_DEMAND"
}
