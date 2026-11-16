output "region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "rds_endpoint" {
  description = "Hostname the backend uses to connect to MySQL"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}

output "rds_secret_arn" {
  description = "Secrets Manager ARN holding the DB master password"
  value       = aws_db_instance.mysql.master_user_secret[0].secret_arn
}

output "nat_public_ip" {
  description = "Outbound IP of the private subnets (the EIP)"
  value       = aws_eip.nat.public_ip
}

output "configure_kubectl" {
  description = "Run this to point kubectl at the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}