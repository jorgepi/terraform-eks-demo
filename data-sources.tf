# Fetching Availability Zones
data "aws_availability_zones" "available" {}

# Fetching Region
data "aws_region" "current" {}

# Fetching EKS workers AMI
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks-master-demo.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}
