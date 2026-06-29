output "db_instance_endpoint" {
   value = aws_db_instance.my_rds.endpoint
   description = "The endpoint of the RDS instance"
}

output "db_instance_address" {
   value = aws_db_instance.my_rds.address
   description = "The address of the RDS instance"
}