output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.web_template.id
}
