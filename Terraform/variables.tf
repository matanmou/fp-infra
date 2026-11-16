variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "for resource names"
  type        = string
  default     = "ipltb"
}

# ---------- Network ----------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the 2 public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the 2 private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# ---------- EKS ----------
variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

# ---------- Database ----------
variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "ipldb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "matanmo"
}

variable "console_admin_arn" {
  description = "IAM principal used in the AWS console, granted EKS admin"
  type        = string
  default     = "arn:aws:iam::727742747407:user/ipltbUser"
}