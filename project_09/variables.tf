variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0a627a85fdcfabbaa" # Amazon Linux 2
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}
