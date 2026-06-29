#creating application load balancer
resource "aws_lb" "mylb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet1_id, var.public_subnet2_id]
  enable_deletion_protection = false
  tags = {
    Environment = "production"
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.mylb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn
  }
}

#creating target group
resource "aws_lb_target_group" "mytg" {
  name     = var.tg_name
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#registering targets to target group
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id        = var.instance1_id
  port             = 8000
}
resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id        = var.instance2_id
  port             = 8000
}

#creating auto scaling group and policy
resource "aws_autoscaling_group" "bar" {
  vpc_zone_identifier = [var.public_subnet1_id, var.public_subnet2_id]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  target_group_arns   = [aws_lb_target_group.mytg.arn]
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
}
resource "aws_autoscaling_policy" "my_asp" {
  name                   = var.asp_name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bar.name
}

#creating cloudfront distribution
resource "aws_cloudfront_distribution" "my_cf" {
  origin {
    domain_name = aws_lb.mylb.dns_name
    origin_id   = "ALBOrigin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  enabled             = true
  default_root_object = ""
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALBOrigin"
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  tags = {
    Name = "my_cf"
  }
}