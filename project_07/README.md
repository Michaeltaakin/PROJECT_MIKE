## Project Documentation: Centralized Logging and Monitoring with CloudWatch using Terraform

## Project Overview
In this project, I used Terraform to automate the configuration of Amazon EC2 instances to send their logs and metrics to AWS CloudWatch, and I set up monitoring and alerting to track my instance’s performance in real-time.

The main goal was to:
•	Collect and monitor system logs from my EC2 instances
•	Get automatic alerts if system performance exceeds safe limits
•	Centralize all logs in one place for easy visibility

## Step 1: Creating the Terraform Project Structure

I started by creating a new Terraform folder structure:

![alt text](<screenshots/Screenshot 2025-12-16 132304.png>)


This structure helped me keep the configuration organized and easy to maintain.


## Step 2: Configure the Provider

In my main.tf, I configured the AWS provider so Terraform knows I’m working in AWS:
provider "aws" {
  region = "us-east-2"
}
Step 3: I Created an IAM Role for EC2
Since my EC2 instance needs permission to send logs to CloudWatch, I created an IAM Role and attached a policy to it.
This role is like a “badge” that allows my instance to communicate securely with CloudWatch.

resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "ec2-cloudwatch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

This ensures the EC2 instance can publish metrics and logs to CloudWatch safely.


## Step 4: I Created a Security Group

Next, I created a security group to allow SSH (port 22) and HTTP (port 80) traffic to my EC2 instance.

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = "vpc-xxxxxx" # or use your default VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## Step 5: Create the User Data Script

In my user_data.sh file, I wrote a script that installs and starts the CloudWatch Agent when the EC2 instance launches.

#!/bin/bash
yum update -y
yum install -y amazon-cloudwatch-agent

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/ec2/instance/logs",
            "log_stream_name": "{instance_id}-system-logs"
          }
        ]
      }
    }
}
EOF

systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

This script runs automatically at instance startup.
It ensures the EC2 instance starts sending metrics (like CPU usage) to CloudWatch immediately.

## Step 6: Launch the EC2 Instance

I then created an EC2 instance in Terraform and attached:

•	The IAM role (for CloudWatch access)
•	The security group (for SSH and HTTP)
•	The user data script (for CloudWatch agent setup)


## Step 7: I Created a CloudWatch Log Group

This log group is where the EC2 instance will send its logs.
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/ec2/instance/logs"
  retention_in_days = 7
Step 8: Create an SNS Topic and Subscription
I created an SNS topic that will send alerts via email when the alarm is triggered.
resource "aws_sns_topic" "alert_topic" {
  name = "ec2-alerts-topic"
}

# --- SNS Subscription (Email) ---
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email 

Then I confirmed the email sent by AWS SNS to activate the subscription.


## Step 9: Create a CloudWatch Alarm

Next, I created an alarm that monitors the EC2 instance’s CPU Utilization.
If CPU usage stays above 70% for a few minutes, it triggers an alert to the SNS topic.

Step 10: Deploy the Infrastructure
Once everything was ready, I ran these Terraform commands:

![alt text](<screenshots/Screenshot 2025-11-05 210204.png>)


After completing this project, I successfully implemented a Centralized Logging and Monitoring System on AWS using Terraform automation.
Through this process, I deployed an EC2 instance configured to automatically send logs and performance metrics to Amazon CloudWatch, and I integrated CloudWatch Alarms with Amazon SNS to receive real-time email alerts whenever the system performance exceeds the defined threshold.

I verified that:
•	The EC2 instance was running and actively publishing metrics to CloudWatch.

![alt text](<screenshots/Screenshot 2025-11-05 220044.png>)


![alt text](<screenshots/Screenshot 2025-11-05 210927.png>)


The CloudWatch alarm (HighCPUUsage) was created successfully and is monitoring CPU utilization as 
expected.

![alt text](<screenshots/Screenshot 2025-11-05 211122.png>)

![alt text](<screenshots/Screenshot 2025-11-05 211750.png>)
 
![alt text](<screenshots/Screenshot 2025-11-05 211716.png>)


The SNS topic and email subscription were properly configured, and the alert notification was received after email confirmation.

![alt text](<screenshots/Screenshot 2025-11-05 215316.png>) 

All AWS resources — EC2, IAM Role, CloudWatch Log Group, Alarm, and SNS — were deployed automatically through Terraform scripts with no manual setup required.

![alt text](<screenshots/Screenshot 2025-11-05 211750.png>)


This project demonstrates the ability to use Infrastructure as Code (IaC) to automate not just resource deployment, but also operational monitoring and alerting. It ensures that any unusual CPU activity or server performance issues are detected immediately and reported automatically improving visibility, reliability, and operational efficiency across the environment.