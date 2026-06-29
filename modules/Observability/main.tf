#creating a sns topic and subscription
resource "aws_sns_topic" "ec2cpuusage" {
  name = var.aws_sns_topic_ec2_usage
}
resource "aws_sns_topic_subscription" "ec2cpuusage_email" {
  topic_arn = aws_sns_topic.ec2cpuusage.arn
  protocol  = var.aws_sns_topic_protocol
  endpoint  = var.aws_sns_topic_endpoint
}
resource "aws_sns_topic" "errors" {
  name = var.aws_sns_topic_errors
}
resource "aws_sns_topic_subscription" "errors_email" {
  topic_arn = aws_sns_topic.errors.arn
  protocol  = var.aws_sns_topic_protocol
  endpoint  = var.aws_sns_topic_endpoint
}

#creating cloudwatch alarms
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name                = "ec2_cpu_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Triggers when ec2 cpu utilization exceeds threshold"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
  alarm_actions     = [var.autoscaling_policy_arn, aws_sns_topic.ec2cpuusage.arn]
}
resource "aws_cloudwatch_metric_alarm" "alb_5xx_alarm" {
  alarm_name          = "alb_5xx_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Triggers when ALB 5XX errors exceed threshold"
  dimensions = {
    LoadBalancer = var.lb_arn_suffix
  }
  alarm_actions             = [aws_sns_topic.errors.arn]
  insufficient_data_actions = []
}