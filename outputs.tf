#mentioning the outputs
output "cloudfront_url" {
  value = module.LoadBalancer.cloudfront_domain_name
}

output "alb_dns" {
  value = module.LoadBalancer.lb_dns_name
}

output "rds_endpoint" {
  value = module.Database.db_instance_address
}