variable "alb_sg_name" {
  description = "Name of the ALB security group"
  type        = string
  default     = "alb_sg"
}

variable "alb_sg_tags" {
  description = "Tags for the ALB security group"
  type        = string
  default     = "alb_sg"
}

variable "cidr_ipv4" {
  description = "cidr value for ipv4 address"
  type = string
  default = "0.0.0.0/0"
}

variable "ip_protocol" {
  description = "IP protocol"
  type = string
  default = "tcp"
}

variable "ec2_sg_name" {
  description = "Name of the EC2 security group"
  type        = string
  default     = "ec2_sg"
}

variable "ec2_sg_tags" {
  description = "Tags for the EC2 security group"
  type        = string
  default     = "ec2_sg"
}

variable "rds_sg_name" {
  description = "Name of the RDS security group"
  type        = string
  default     = "rds_sg"
}

variable "rds_sg_tags" {
  description = "Tags for the RDS security group"
  type        = string
  default     = "rds_sg"
}

variable "iam_role_for_ec2" {
  description = "IAM role for EC2 instances"
  type        = string
  default     = "ec2_role"
}

variable "iam_instance_profile_for_ec2" {
  default = "ec2_profile"
  type = string
  description = "IAM instance profile for EC2 instances"
}

variable "vpc_id" {
  description = "VPC ID from the Networking module"
  type        = string
}

variable "private_app_subnet1_id" {
  description = "Private app subnet ID from the Networking module, used for the EC2 Instance Connect Endpoint"
  type        = string
}