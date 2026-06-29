#creating ec2 instance
resource "aws_instance" "my_instance1" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = var.public_subnet1_id
  vpc_security_group_ids = [var.ec2_sg_id]
  availability_zone      = var.ec2_availability_zone1
  key_name               = var.ec2_key_name
  iam_instance_profile = var.iam_instance_profile_for_ec2
  user_data = base64encode(templatefile("${path.root}/userdata.sh", {
  db_host     = var.db_host
  db_password = var.db_password
}))
  tags = {
    Name = var.ec2_tags
  }
}
resource "aws_instance" "my_instance2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = var.public_subnet2_id
  vpc_security_group_ids = [var.ec2_sg_id]
  availability_zone      = var.ec2_availability_zone2
  key_name               = var.ec2_key_name
  iam_instance_profile = var.iam_instance_profile_for_ec2
  user_data = base64encode(templatefile("${path.root}/userdata.sh", {
  db_host     = var.db_host
  db_password = var.db_password
}))
  tags = {
    Name = var.ec2_tags2
  }
}

#creating launch template
resource "aws_launch_template" "my_lt" {
  name = var.launch_template_name
  image_id = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.ec2_key_name
  vpc_security_group_ids = [var.ec2_sg_id]
  iam_instance_profile{
    name = var.iam_instance_profile_for_ec2
  } 
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.launch_template_tags
    }
  }
  user_data = base64encode(templatefile("${path.root}/userdata.sh", {
  db_host     = var.db_host
  db_password = var.db_password
}))
}