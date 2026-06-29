variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "mylb"
}

variable "tg_name" {
  description = "Name of the target group"
  type        = string
  default     = "mytg"
}

variable "asg_name" {
  description = "Name of the auto scaling group"
  type        = string
  default     = "bar"
}

variable "asp_name" {
  description = "Name of autoscaling policy"
  type = string
  default = "my_asp"
}

variable "cf_name" {
  description = "Cloudfront distribution name"
  type = string
  default = "my_cf"
}

variable "vpc_id" {
  description = "VPC ID from the Networking module"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB security group ID from the Security module"
  type        = string
}

variable "public_subnet1_id" {
  description = "Public app subnet 1 ID from the Networking module"
  type        = string
}

variable "public_subnet2_id" {
  description = "Public app subnet 2 ID from the Networking module"
  type        = string
}

variable "instance1_id" {
  description = "Instance 1 ID from the Compute module"
  type        = string
}

variable "instance2_id" {
  description = "Instance 2 ID from the Compute module"
  type        = string
}

variable "launch_template_id" {
  description = "Launch template ID from the Compute module"
  type        = string
}