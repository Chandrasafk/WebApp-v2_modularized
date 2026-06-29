#terraform configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }
}

#credentials and provider configuration
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "Compute" {
  source                       = "./modules/Compute"
  db_password                  = var.db_password
  db_host                      = module.Database.db_instance_address
  iam_instance_profile_for_ec2 = module.Security.iam_instance_profile
  public_subnet1_id            = module.Networking.public_app_subnet1_id
  public_subnet2_id            = module.Networking.public_app_subnet2_id
  ec2_sg_id                    = module.Security.ec2_sg_id
}

module "Database" {
  source        = "./modules/Database"
  db_username   = var.db_username
  db_password   = var.db_password
  db_subnet1_id = module.Networking.private_db_subnet1_id
  db_subnet2_id = module.Networking.private_db_subnet2_id
  rds_sg_id     = module.Security.rds_sg_id
}

module "LoadBalancer" {
  source             = "./modules/LoadBalancer"
  vpc_id             = module.Networking.vpc_id
  alb_sg_id          = module.Security.alb_sg_id
  public_subnet1_id  = module.Networking.public_app_subnet1_id
  public_subnet2_id  = module.Networking.public_app_subnet2_id
  instance1_id       = module.Compute.instance1_id
  instance2_id       = module.Compute.instance2_id
  launch_template_id = module.Compute.launch_template_id
}

module "Networking" {
  source = "./modules/Networking"
}

module "Observability" {
  source                 = "./modules/Observability"
  autoscaling_group_name = module.LoadBalancer.asg_name
  autoscaling_policy_arn = module.LoadBalancer.asp_arn
  lb_arn_suffix          = module.LoadBalancer.lb_arn_suffix
}

module "Security" {
  source                 = "./modules/Security"
  vpc_id                 = module.Networking.vpc_id
  private_app_subnet1_id = module.Networking.private_app_subnet1_id
}
