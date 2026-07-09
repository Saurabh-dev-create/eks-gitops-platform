module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  version = "~> 6.0"

  name = var.vpc_name

  cidr = var.vpc_cidr

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  public_subnet_tags = {
  "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
  "kubernetes.io/role/internal-elb" = "1"
  "kubernetes.io/cluster/${var.cluster_name}" = "shared"
 }

  enable_nat_gateway = true

  single_nat_gateway = true

  enable_dns_hostnames = true

  enable_dns_support = true

  tags = {
    Project     = "Enterprise Platform"
    Environment = "Production"
    Terraform   = "true"
  }

}

module "eks" {

  source = "terraform-aws-modules/eks/aws"

  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access = true

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {

    platform = {

      instance_types = [var.node_instance_type]
      capacity_type = var.capacity_type

      min_size = var.min_size

      max_size = var.max_size

      desired_size = var.desired_size

    }

  }

  tags = {

    Project = "Enterprise Platform"

    Terraform = "true"

  }

}
