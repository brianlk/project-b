# locals {
#   k8s_output = {
#     id = aws_eks_cluster.eks.id
#     status = aws_eks_cluster.eks.status
#   }
# }

output "cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "cert" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

