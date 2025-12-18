variable "region" {
  default = "us-east-2"
}

# variables.tf
variable "instance_id" {
  description = "The EC2 instance ID to start/stop"
  type        = string
  default     = "i-0aa1f5165af640bcb"
}
