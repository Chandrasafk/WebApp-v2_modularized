variable "ec2_tags"{
  description = "Tags for EC2 instance"
  type        = string
  default     = "my_instance1"
}

variable "ec2_tags2"{
  description = "Tags for EC2 instance"
  type        = string
  default     = "my_instance2"
}

variable "ec2_ami" {
  description = "AMI for ec2"
  type = string
  default = "ami-0236922087fa98b6e"
}

variable "ec2_instance_type" {
  description = "Instance type for ec2"
  type = string
  default = "t3.micro"
}

variable "ec2_key_name" {
  description = "Key name for ec2"
  type = string
  default = "use1keypair"
}

variable "ec2_availability_zone1" {
  description = "Availability zone for ec2 instance 1"
  type = string
  default = "us-east-1a"
}

variable "ec2_availability_zone2" {
  description = "Availability zone for ec2 instance 2"
  type = string
  default = "us-east-1b"
}

variable "iam_instance_profile_for_ec2" {
  default = "ec2_profile"
  type = string
  description = "IAM instance profile for EC2 instances"
}

variable "launch_template_name" {
  description = "Name for launch template"
  type = string
  default = "my_lt"
}

variable "launch_template_tags" {
  description = "Tags for launch template"
  type = string
  default = "my_lt_instance"
}

variable "db_host" {
  description = "Database host for user data script"
  type = string
}

variable "db_password" {
  description = "Password for the DB instance"
  type        = string
  sensitive = true
}

variable "public_subnet1_id" {
  description = "Public app subnet 1 ID from the Networking module"
  type        = string
}

variable "public_subnet2_id" {
  description = "Public app subnet 2 ID from the Networking module"
  type        = string
}

variable "ec2_sg_id" {
  description = "EC2 security group ID from the Security module"
  type        = string
}