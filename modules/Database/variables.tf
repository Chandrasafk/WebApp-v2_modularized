variable "db_subnet_group_name" {
  description = "Name of the RDS subnet group"
  type        = string
  default     = "main"
}

variable "db_instance_tags" {
  description = "Tags for the RDS instance"
  type        = string
  default     = "my_rds"
}

variable "rds_subnet_group_tags" {
  description = "Tags for the RDS subnet group"
  type        = string
  default     = "aws_db_subnet_group"
}

variable "db_instance_class" {
  description = "Instance class for the DB instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "Database engine for the DB instance"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version for the DB instance"
  type        = string
  default     = "8.0"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "my_rds"
}

variable "db_availability_zone" {
  description = "Availability zone for the DB instance"
  type        = string
  default     = "us-east-1a"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the DB instance"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Username for the DB instance"
  type        = string
  sensitive = true
}

variable "db_password" {
  description = "Password for the DB instance"
  type        = string
  sensitive = true
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "chandra-project-app-bucket"
}

variable "s3_bucket_tags" {
  description = "Tags for the S3 bucket"
  type        = string
  default     = "My bucket"
}

variable "db_subnet1_id" {
  description = "Private DB subnet 1 ID from the Networking module"
  type        = string
}

variable "db_subnet2_id" {
  description = "Private DB subnet 2 ID from the Networking module"
  type        = string
}

variable "rds_sg_id" {
  description = "RDS security group ID from the Security module"
  type        = string
}