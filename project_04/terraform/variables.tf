variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  description = "michael-key"
  type        = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-077b630ef539aa0b5" # Example for us-east-1
}
