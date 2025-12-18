# outputs.tf

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.my_server.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.my_server.public_ip
}

output "cloudwatch_log_group" {
  description = "Name of CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.ec2_logs.name
}
