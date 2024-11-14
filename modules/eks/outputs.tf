output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.this.arn
}

output "node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.this.node_group_name
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}
