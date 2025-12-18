##############################################################
# AWS REGION
##############################################################
variable "aws_region" {
  description = "AWS Region to deploy resources"
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "public_instance_count" {
  description = "Number of public EC2 instances"
  default     = 2
}

variable "private_instance_count" {
  description = "Number of private EC2 instances"
  default     = 1
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-00e428798e77d38d9" # Amazon Linux 2 (us-east-2)
}

