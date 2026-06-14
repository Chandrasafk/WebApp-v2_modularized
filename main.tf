#credentials and provider configuration
provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#creating vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "my_vpc"
  }
}

#creating subnets
resource "aws_subnet" "publicappsubnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicappsubnet1"
  }
}
resource "aws_subnet" "publicappsubnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicappsubnet2"
  }
}
resource "aws_subnet" "privateappsubnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "privateappsubnet1"
  }
}
resource "aws_subnet" "privateappsubnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "privateappsubnet2"
  }
}
resource "aws_subnet" "privatedbsubnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "privatedbsubnet1"
  }
}
resource "aws_subnet" "privatedbsubnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "privatedbsubnet2"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "my_int_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_int_gw"
  }
}

#creating route tables and associations
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_int_gw.id
  }
  tags = {
    Name = "public_route_table"
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.publicappsubnet1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_route_table_association1" {
  subnet_id      = aws_subnet.publicappsubnet2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "private_route_table_association2" {
  subnet_id      = aws_subnet.privateappsubnet1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association3" {
  subnet_id      = aws_subnet.privateappsubnet2.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association4" {
  subnet_id      = aws_subnet.privatedbsubnet1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association5" {
  subnet_id      = aws_subnet.privatedbsubnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

#creating security groups
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow http inbound traffic from internet and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  tags = {
    Name = "alb_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow http inbound traffic from alb and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  tags = {
    Name = "ec2_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow" {
  security_group_id = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id #source of traffic is alb security group
  from_port         = 8000
  ip_protocol       = "tcp"
  to_port           = 8000
}
resource "aws_vpc_security_group_ingress_rule" "allow_ipv4_from_ec2" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0" #allowing ssh access to ec2 instances from anywhere, in production this should be restricted to specific ip addresses
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic from ec2 to rds"
  vpc_id      = aws_vpc.my_vpc.id
  tags = {
    Name = "rds_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allows" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id #source of traffic is ec2 security group
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffics" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#creating rds subnet group
resource "aws_db_subnet_group" "rds_sg" {
  name       = "main"
  subnet_ids = [aws_subnet.privatedbsubnet1.id, aws_subnet.privatedbsubnet2.id]
  tags = {
    Name = "rds_sg"
  }
}

#creating rds instance
resource "aws_db_instance" "my_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "my_rds"
  username             = "admin"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds_sg.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  availability_zone = "us-east-1a"
  skip_final_snapshot = true
  publicly_accessible  = false
  tags = {
    Name = "my_rds"
  }
}

#creating ec2 instance
resource "aws_instance" "my_instance1" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.publicappsubnet1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = "use1keypair"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
  db_host     = aws_db_instance.my_rds.address
  db_password = var.db_password
}))
  tags = {
    Name = "my_instance1"
  }
}
resource "aws_instance" "my_instance2" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.publicappsubnet2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  availability_zone      = "us-east-1b"
  key_name               = "use1keypair"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
  db_host     = aws_db_instance.my_rds.address
  db_password = var.db_password
}))
  tags = {
    Name = "my_instance2"
  }
}

#creating target group
resource "aws_lb_target_group" "mytg" {
  name     = "mytg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
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
  target_id        = aws_instance.my_instance1.id
  port             = 8000
}
resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id        = aws_instance.my_instance2.id
  port             = 8000
}

#creating application load balancer
resource "aws_lb" "mylb" {
  name               = "mylb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.publicappsubnet1.id, aws_subnet.publicappsubnet2.id]
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

#creating launch template
resource "aws_launch_template" "my_lt" {
  name = "my_lt"
  image_id = "ami-0236922087fa98b6e"
  instance_type = "t3.micro"
  key_name = "use1keypair"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile{
    name = aws_iam_instance_profile.ec2_profile.name
  } 
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my_lt_instance"
    }
  }
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
  db_host     = aws_db_instance.my_rds.address
  db_password = var.db_password
}))
}

#creating auto scaling group and policy
resource "aws_autoscaling_group" "bar" {
  vpc_zone_identifier = [aws_subnet.publicappsubnet1.id, aws_subnet.publicappsubnet2.id]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  target_group_arns   = [aws_lb_target_group.mytg.arn]
  launch_template {
    id      = aws_launch_template.my_lt.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_policy" "my_asp" {
  name                   = "my_asp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bar.name
}

#creating a sns topic and subscription
resource "aws_sns_topic" "ec2cpuusage" {
  name = "ec2-cpu-usage-topic"
}
resource "aws_sns_topic_subscription" "ec2cpuusage_email" {
  topic_arn = aws_sns_topic.ec2cpuusage.arn
  protocol  = "email"
  endpoint  = "giri.s.chandrashekar@gmail.com"
}
resource "aws_sns_topic" "errors" {
  name = "errors-topic"
}
resource "aws_sns_topic_subscription" "errors_email" {
  topic_arn = aws_sns_topic.errors.arn
  protocol  = "email"
  endpoint  = "giri.s.chandrashekar@gmail.com"
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
    AutoScalingGroupName = aws_autoscaling_group.bar.name
  }
  alarm_actions     = [aws_autoscaling_policy.my_asp.arn, aws_sns_topic.ec2cpuusage.arn]
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
    LoadBalancer = aws_lb.mylb.arn_suffix
  }
  alarm_actions             = [aws_sns_topic.errors.arn]
  insufficient_data_actions = []
}

#creating s3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "chandra-project-app-bucket"

  tags = {
    Name        = "My bucket"
  }
}

#creating ec2 instance connect endpoint
resource "aws_ec2_instance_connect_endpoint" "example" {
  subnet_id = aws_subnet.privateappsubnet1.id
  security_group_ids = [aws_security_group.ec2_sg.id]
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

#mentioning the outputs
output "cloudfront_url" {
  value = aws_cloudfront_distribution.my_cf.domain_name
}

output "alb_dns" {
  value = aws_lb.mylb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.my_rds.address
}

#creating an iam instance profile and role for ssm
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}