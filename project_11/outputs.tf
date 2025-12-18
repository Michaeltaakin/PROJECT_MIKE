output "lambda_start_function_name" {
  description = "Name of the Lambda function that starts the EC2 instance"
  value       = aws_lambda_function.start_lambda.function_name
}

output "lambda_stop_function_name" {
  description = "Name of the Lambda function that stops the EC2 instance"
  value       = aws_lambda_function.stop_lambda.function_name
}

output "lambda_start_function_arn" {
  description = "ARN of the Lambda function that starts EC2"
  value       = aws_lambda_function.start_lambda.arn
}

output "lambda_stop_function_arn" {
  description = "ARN of the Lambda function that stops EC2"
  value       = aws_lambda_function.stop_lambda.arn
}

output "start_schedule_rule_arn" {
  description = "CloudWatch rule ARN for starting the EC2 instance"
  value       = aws_cloudwatch_event_rule.start_rule.arn
}

output "stop_schedule_rule_arn" {
  description = "CloudWatch rule ARN for stopping the EC2 instance"
  value       = aws_cloudwatch_event_rule.stop_rule.arn
}

output "lambda_execution_role" {
  description = "IAM role used by Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "instance_id_being_managed" {
  description = "The EC2 instance ID that Lambda will start/stop on schedule"
  value       = var.instance_id
}
