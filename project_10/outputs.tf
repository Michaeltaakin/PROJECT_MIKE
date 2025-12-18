output "ec2_role_arn" {
  value       = aws_iam_role.ec2_role.arn
  description = "ARN of the EC2 IAM role created"
}

output "ec2_instance_profile" {
  value       = aws_iam_instance_profile.ec2_profile.name
  description = "EC2 Instance Profile Name"
}

output "s3_policy_arn" {
  value       = aws_iam_policy.s3_policy.arn
  description = "ARN of S3 policy"
}

output "cloudwatch_policy_arn" {
  value       = aws_iam_policy.cloudwatch_policy.arn
  description = "ARN of CloudWatch policy"
}
