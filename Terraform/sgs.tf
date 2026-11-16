# ---------- Security Groups ----------
# ---------- RDS Security Group ----------
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "RDS MySQL - traffic from EKS nodes only"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${var.project_name}-rds-sg" }
}

# ---------- EKS -> RDS Security Group ----------
resource "aws_vpc_security_group_ingress_rule" "rds_from_eks" {
  security_group_id            = aws_security_group.rds.id
  description                  = "MySQL from EKS nodes/pods"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

