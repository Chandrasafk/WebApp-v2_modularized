output "lb_name" {
  value = aws_lb.mylb.name
}

output "lb_arn" {
  value = aws_lb.mylb.arn
}

output "asg_name" {
  value = aws_autoscaling_group.bar.name
}

output "asp_arn" {
  value = aws_autoscaling_policy.my_asp.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.my_cf.domain_name
}

output "lb_dns_name" {
  value = aws_lb.mylb.dns_name
}

output "lb_arn_suffix" {
  value = aws_lb.mylb.arn_suffix
}