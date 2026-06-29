#creating security groups
resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Allow http inbound traffic from internet and all outbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.alb_sg_tags
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 80
  ip_protocol       = var.ip_protocol
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.cidr_ipv4
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_sg_name
  description = "Allow http inbound traffic from alb and all outbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.ec2_sg_tags
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow" {
  security_group_id = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id #source of traffic is alb security group
  from_port         = 8000
  ip_protocol       = var.ip_protocol
  to_port           = 8000
}
resource "aws_vpc_security_group_ingress_rule" "allow_ipv4_from_ec2" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.cidr_ipv4 #allowing ssh access to ec2 instances from anywhere, in production this should be restricted to specific ip addresses
  from_port         = 22
  ip_protocol       = var.ip_protocol
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.cidr_ipv4
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg_name
  description = "Allow traffic from ec2 to rds"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.rds_sg_tags
  }
}
resource "aws_vpc_security_group_ingress_rule" "allows" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id #source of traffic is ec2 security group
  from_port         = 3306
  ip_protocol       = var.ip_protocol
  to_port           = 3306
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffics" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = var.cidr_ipv4
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#creating an iam instance profile and role for ssm
resource "aws_iam_role" "ec2_role" {
  name = var.iam_role_for_ec2

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
  name = var.iam_instance_profile_for_ec2
  role = aws_iam_role.ec2_role.name
}

#creating ec2 instance connect endpoint
resource "aws_ec2_instance_connect_endpoint" "example" {
  subnet_id          = var.private_app_subnet1_id
  security_group_ids = [aws_security_group.ec2_sg.id]
}