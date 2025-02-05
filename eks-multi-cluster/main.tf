# Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.70.0"
    }
  }
}

# Filter out local zones, which are not currently supported with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Create the VPCs
module "vpc" {
  count      = length(var.vpcs)
  source     = "terraform-aws-modules/vpc/aws"
  version    = "5.8.1"
  depends_on = []

  azs                     = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr                    = var.vpcs[count.index].cidr_block
  enable_nat_gateway      = false
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true
  name                    = "${var.resource_prefix}-${var.vpcs[count.index].name}-vpc"
  private_subnets         = var.vpcs[count.index].private_subnets
  public_subnets          = var.vpcs[count.index].public_subnets
}

# Security group for access to the clusters
resource "aws_security_group" "cluster_sg" {
  count = length(var.vpcs)
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "all-egress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "all"
    from_port   = 0
    protocol    = "tcp"
    to_port     = 0
  }
  name = "${module.vpc[count.index].name}-sg"
  tags = {
    Name = "${module.vpc[count.index].name}-sg"
  }
  vpc_id = module.vpc[count.index].vpc_id
}

# Create the EKS clusters
module "eks" {
  count  = length(var.vpcs)
  source = "terraform-aws-modules/eks/aws"
  depends_on = [
    module.vpc,
    aws_iam_role_policy_attachment.cluster_eks_block_storage_policy,
    aws_iam_role_policy_attachment.cluster_eks_cluster_policy,
    aws_iam_role_policy_attachment.cluster_eks_compute_policy,
    aws_iam_role_policy_attachment.cluster_eks_load_balancing_policy,
    aws_iam_role_policy_attachment.cluster_eks_networking_policy
  ]
  cluster_endpoint_public_access           = true
  cluster_name                             = "${var.resource_prefix}-${var.vpcs[count.index].name}-cluster"
  cluster_version                          = var.kubernetes_version
  enable_cluster_creator_admin_permissions = true
  eks_managed_node_groups = {
    ng1 = {
      desired_size   = var.eks_node_group_size
      instance_types = [var.eks_node_type]
      max_size       = var.eks_node_group_size
      min_size       = var.eks_node_group_size
      name           = "${var.vpcs[count.index].name}-ng"
    }
  }
  eks_managed_node_group_defaults = {
    ami_type = "AL2023_x86_64_STANDARD"
  }
  subnet_ids = module.vpc[count.index].public_subnets
  vpc_id     = module.vpc[count.index].vpc_id
}

# EKS cluster permissions
resource "aws_iam_role" "cluster" {
  name = "eks-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# EKS cluster policy attachments
resource "aws_iam_role_policy_attachment" "cluster_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}
resource "aws_iam_role_policy_attachment" "cluster_eks_compute_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.cluster.name
}
resource "aws_iam_role_policy_attachment" "cluster_eks_block_storage_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.cluster.name
}
resource "aws_iam_role_policy_attachment" "cluster_eks_load_balancing_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.cluster.name
}
resource "aws_iam_role_policy_attachment" "cluster_eks_networking_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.cluster.name
}