locals {
  k8s_output = {
    id = aws_eks_cluster.eks.id
    status = aws_eks_cluster.eks.status
  }
}

output "cluster_id" {
  value = local.k8s_output.id
}

output "cluster_status" {
  value = local.k8s_output.status
}