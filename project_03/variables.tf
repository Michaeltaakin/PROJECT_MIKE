variable "aws_region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-0ca4d5db4872d0c28" # Change this if you're not in us-east-1
}

variable "key_name" {
  description = "michael-key"
  type        = string
  default     = "michael-key" # Replace with your actual key name or override via CLI
}
