output "instance_id" {
  description = "ID of the EC2 application server"
  value       = aws_instance.application.id
}

output "private_ip" {
  description = "Private IP address of the EC2 application server"
  value       = aws_instance.application.private_ip
}