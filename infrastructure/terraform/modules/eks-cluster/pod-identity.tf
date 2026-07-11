module "aws_ebs_csi_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.8"

  name = "${var.cluster_name}-ebs-csi"

  attach_aws_ebs_csi_policy = true

  associations = {
    this = {
      cluster_name    = module.eks.cluster_name
      namespace       = "kube-system"
      service_account = "ebs-csi-controller-sa"
    }
  }

  tags = {
    Project     = "Enterprise Platform"
    Environment = var.environment
    Terraform   = "true"
  }
}
