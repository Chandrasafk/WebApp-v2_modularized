#creating rds subnet group
resource "aws_db_subnet_group" "aws_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = [var.db_subnet1_id, var.db_subnet2_id]
  tags = {
    Name = var.rds_subnet_group_tags
  }
}

#creating rds instance
resource "aws_db_instance" "my_rds" {
  allocated_storage    = var.db_allocated_storage
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.aws_db_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]
  availability_zone = var.db_availability_zone
  skip_final_snapshot = true
  publicly_accessible  = false
  tags = {
    Name = var.db_instance_tags
  }
}

#creating s3 bucket
resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket_name
  tags = {
    Name  = var.s3_bucket_tags
  }
}