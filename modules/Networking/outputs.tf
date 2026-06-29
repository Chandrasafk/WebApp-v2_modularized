output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_app_subnet1_id" {
  value = aws_subnet.publicappsubnet1.id
}

output "public_app_subnet2_id" {
  value = aws_subnet.publicappsubnet2.id
}

output "private_app_subnet1_id" {
  value = aws_subnet.privateappsubnet1.id
}

output "private_app_subnet2_id" {
  value = aws_subnet.privateappsubnet2.id
}

output "private_db_subnet1_id" {
  value = aws_subnet.privatedbsubnet1.id
}

output "private_db_subnet2_id" {
  value = aws_subnet.privatedbsubnet2.id
}