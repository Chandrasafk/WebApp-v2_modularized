variable "vpc_name"{
    description = "Name of the VPC"
    type        = string
    default     = "my_vpc"
}

variable "vpc_cidr"{
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_app_subnet1_name" {
    description = "Subnet name for Instances in public subnet"
    type = string
    default = "publicappsubnet1"
}

variable "public_app_subnet1_id" {
    description = "CIDR block for Public Subnet 1"
    type = string
    default = "10.0.1.0/24"
}

variable "public_app_subnet2_name" {
    description = "Subnet name for Instances in public subnet"
    type = string
    default = "publicappsubnet2"
}

variable "public_app_subnet2_id" {
    description = "CIDR block for Public Subnet 2"
    type = string
    default = "10.0.2.0/24"
}

variable "private_app_subnet1_name" {
    description = "Subnet name for Instances in public subnet"
    type = string
    default = "privateappsubnet1"
}

variable "private_app_subnet1_id" {
    description = "CIDR block for Private Subnet 1"
    type = string
    default = "10.0.3.0/24"
}

variable "private_app_subnet2_name" {
    description = "Subnet name for Instances in public subnet"
    type = string
    default = "privateappsubnet2"
}

variable "private_app_subnet2_id" {
    description = "CIDR block for Private Subnet 2"
    type = string
    default = "10.0.4.0/24"
}

variable "private_db_subnet1_name" {
    description = "Subnet name for Instances in public subnet"
    type = string
    default = "privatedbsubnet1"
}

variable "private_db_subnet1_id" {
    description = "CIDR block for Private Database Subnet 1"
    type = string
    default = "10.0.5.0/24"
}

variable "private_db_subnet2_name" {
    description = "Subnet name for Instances in public subnet"
    type = string
    default = "privatedbsubnet2"
}

variable "private_db_subnet2_id" {
    description = "CIDR block for Private Database Subnet 2"
    type = string
    default = "10.0.6.0/24"
}

variable "availability_zone1_value" {
    description = "Availability zone in us east"
    type = string
    default = "us-east-1a"
}

variable "availability_zone2_value" {
    description = "Availability zone in us east"
    type = string
    default = "us-east-1b"
}

variable "igw_name" {
    description = "Name of Internet Gateway"
    type = string
    default = "my_igw"
}

variable "igw_cidr" {
    description = "CIDR for internet gateway"
    type = string
    default = "0.0.0.0/0"
}

variable "public_route_table_name" {
    description = "Name of public route table"
    type = string
    default = "public_route_table"
}

variable "private_route_table_name" {
    description = "Name of private route table"
    type = string
    default = "private_route_table"
}