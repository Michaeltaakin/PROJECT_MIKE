# main.tf

# --- Provider ---
provider "aws" {
  region = var.aws_region
}

# --- IAM Role for EC2 to use CloudWatch ---
resource "aws_iam_role" "ec2_role" {
  name = "ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach CloudWatch Agent policy
resource "aws_iam_role_policy_attachment" "cw_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# --- Security Group for EC2 ---
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-cw-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "cloudwatch-ec2-sg"
  }
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# --- CloudWatch Log Group ---
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/ec2/instance/logs"
  retention_in_days = 7
}

# --- EC2 Instance ---
resource "aws_instance" "my_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("user_data.sh")

  tags = {
    Name = "Logging-EC2"
  }
}

# --- SNS Topic for Email Alerts ---
resource "aws_sns_topic" "alert_topic" {
  name = "ec2-alerts-topic"
}

# --- SNS Subscription (Your Email) ---
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email  # we'll define this in variables.tf
}

# --- CloudWatch Alarm ---
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUUsage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers if CPU exceeds 70% for 4 minutes"
  dimensions = {
    InstanceId = aws_instance.my_server.id
  }
   alarm_actions = [aws_sns_topic.alert_topic.arn] # You can later add SNS topic for alerts
}


