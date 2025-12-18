# variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-2"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID"
  default     = "ami-0049e4b5ba14b6d36"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of your EC2 key pair"
  default     = "michael-key"
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alerts"
  default     = "michaeltaakin@gmail.com"
}

