variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-2"
}

variable "ec2_role_name" {
  type        = string
  description = "Name for the IAM role used by EC2"
  default     = "tf-ec2-role"
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket EC2 should access"
  default     = "arn:aws:s3:::my-webapp-bucket2"
}
