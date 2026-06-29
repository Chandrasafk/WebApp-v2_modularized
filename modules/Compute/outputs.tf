output "instance1_id" {
  value = aws_instance.my_instance1.id
}

output "instance2_id" {
  value = aws_instance.my_instance2.id
}

output "launch_template_id" {
  value = aws_launch_template.my_lt.id
}