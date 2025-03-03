output "cluster_names" {
  description = "The names of the clusters created"
  value       = [for cluster in module.eks : cluster.cluster_name]
}
output "update_kubeconfigs" {
  description = "Commands to update kubeconfig(s)"
  value       = [for cluster in module.eks : "aws eks update-kubeconfig --region ${var.aws_region} --name ${cluster.cluster_name}"]
}
output "vpcs" {
  description = "VPCs created"
  value       = [for vpc in module.vpc : "id=${vpc.vpc_id}, cidr block=${vpc.vpc_cidr_block}"]
}

