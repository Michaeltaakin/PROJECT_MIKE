output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_ec2_ips" {
  value = [for instance in aws_instance.public_ec2 : instance.public_ip]
}

output "public_ec2_azs" {
  value = [for instance in aws_instance.public_ec2 : instance.availability_zone]
}


