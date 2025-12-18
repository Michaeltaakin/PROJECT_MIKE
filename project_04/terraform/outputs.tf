output "elb_dns_name" {
  description = "Public DNS name of the load balancer"
  value       = aws_elb.web_elb.dns_name
}

output "instance_public_ips" {
  value = [for instance in aws_instance.web : instance.public_ip]
}
