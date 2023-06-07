# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "${var.project}-vpc"

  cidr = var.network-ip-range
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets = var.private-net
  public_subnets  = var.public-net

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

# resource "aws_iam_role" "eks-iam-role" {
#   name = "${var.project}-eks-iam-role"

#   path = "/"

#   assume_role_policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#    ]
#   }
#   EOF
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role    = aws_iam_role.eks-iam-role.name
# }
# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role    = aws_iam_role.eks-iam-role.name
# }


resource "aws_eks_cluster" "eks" {
  name = "${var.project}-cluster"
  role_arn = var.iam-role-eks-arn

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }

  # TODO
  depends_on = [
    # aws_iam_role.eks-iam-role,
  ]
}

# resource "aws_iam_role" "workernodes" {
#   name = "eks-node-group-example"
 
#   assume_role_policy = jsonencode({
#    Statement = [{
#     Action = "sts:AssumeRole"
#     Effect = "Allow"
#     Principal = {
#      Service = "ec2.amazonaws.com"
#     }
#    }]
#    Version = "2012-10-17"
#   })
# }
 
# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role    = aws_iam_role.workernodes.name
# }
 
# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role    = aws_iam_role.workernodes.name
# }
 
# resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
#   policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
#   role    = aws_iam_role.workernodes.name
# }
 
# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role    = aws_iam_role.workernodes.name
# }

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.eks.name
  node_group_name = "${var.project}-workernodes"
  node_role_arn  = var.iam-role-node-arn
  subnet_ids   = module.vpc.public_subnets
  instance_types = ["t2.micro"]
 
  scaling_config {
    desired_size = 1
    max_size   = 1
    min_size   = 1
  }
 
  # TODO
  depends_on = [
   # aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   # aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   ##aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

