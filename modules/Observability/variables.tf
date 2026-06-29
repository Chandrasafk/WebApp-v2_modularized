variable "aws_sns_topic_ec2_usage" {
  type = string
  description = "SNS topic name for EC2 Usage"
  default = "ec2-cpu-usage-topic"
}

variable "aws_sns_topic_protocol" {
  type = string
  description = "Means for notification"
  default = "email"
}

variable "aws_sns_topic_endpoint" {
  type = string
  description = "Email address for notification"
  default = "giri.s.chandrashekar@gmail.com"
}

variable "aws_sns_topic_errors" {
  type = string
  description = "SNS topic name for errors"
  default = "errors-topic"
}

variable "autoscaling_group_name" {
  description = "Autoscaling group name from the LoadBalancer module"
  type        = string
}

variable "autoscaling_policy_arn" {
  description = "Autoscaling policy ARN from the LoadBalancer module"
  type        = string
}

variable "lb_arn_suffix" {
  description = "ALB ARN suffix from the LoadBalancer module"
  type        = string
}