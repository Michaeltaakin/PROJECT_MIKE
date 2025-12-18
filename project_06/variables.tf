variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
  default     = "michael-static-site-bucket"
}
