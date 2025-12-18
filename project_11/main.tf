terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.region
}

# ----------------------------
# IAM ROLE FOR LAMBDA
# ----------------------------
resource "aws_iam_role" "lambda_role" {
  name = "ec2-scheduler-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "ec2-scheduler-policy"
  description = "Allow Lambda to start/stop EC2"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# ----------------------------
# ZIP THE LAMBDA CODE
# ----------------------------
data "archive_file" "start_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/start_ec2.py"
  output_path = "${path.module}/lambda/start_ec2.zip"
}

data "archive_file" "stop_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/stop_ec2.py"
  output_path = "${path.module}/lambda/stop_ec2.zip"
}

# ----------------------------
# LAMBDA FUNCTIONS
# ----------------------------
resource "aws_lambda_function" "start_lambda" {
  function_name = "StartEC2Function"
  runtime       = "python3.9"
  handler       = "start_ec2.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.start_zip.output_path
  timeout = 10

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

resource "aws_lambda_function" "stop_lambda" {
  function_name = "StopEC2Function"
  runtime       = "python3.9"
  handler       = "stop_ec2.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.stop_zip.output_path
  timeout = 10

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

# ----------------------------
# CLOUDWATCH SCHEDULES
# ----------------------------

# 3:15 AM Start
resource "aws_cloudwatch_event_rule" "start_rule" {
  name        = "start-ec2-schedule"
  description = "Start EC2 daily"
  schedule_expression = "cron(16 16 * * ? *)"
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_rule.name
  target_id = "startEC2"
  arn       = aws_lambda_function.start_lambda.arn

  input = jsonencode({
    instance_id =  "i-0aa1f5165af640bcb"
  })
}

resource "aws_lambda_permission" "allow_start" {
  statement_id  = "AllowCloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_rule.arn
}

# 9:00 PM Stop
resource "aws_cloudwatch_event_rule" "stop_rule" {
  name        = "stop-ec2-schedule"
  description = "Stop EC2 daily"
  schedule_expression = "cron(21 16 * * ? *)"
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_rule.name
  target_id = "stopEC2"
  arn       = aws_lambda_function.stop_lambda.arn

  input = jsonencode({
    instance_id =  "i-0aa1f5165af640bcb"
  })
}

resource "aws_lambda_permission" "allow_stop" {
  statement_id  = "AllowCloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_rule.arn
}
