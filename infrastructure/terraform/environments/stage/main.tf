module "platform_cluster" {

  source = "../../modules/eks-cluster"

  aws_region         = var.aws_region
  azs = var.azs
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  environment        = var.environment
  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  node_instance_type = var.node_instance_type

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size

  capacity_type = var.capacity_type
}
