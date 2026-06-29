variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "db_username" {
  description = "Username for the DB instance"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the DB instance"
  type        = string
  sensitive   = true
}