#### Automating EC2 Start/Stop Using AWS Lambda and CloudWatch Events

# Project Description:

In this project, I automated the process of starting and stopping an EC2 instance using AWS Lambda, EventBridge (CloudWatch), IAM roles, and Terraform. 
Instead of manually signing into the AWS console daily to turn the instance on or off, I built a system that performs these actions automatically at specific times. The Lambda function starts an EC2 instance every day at 3:15 AM and stops it at 9:00 PM, helping reduce costs by running the instance only when it is needed. My goal was to fully automate the EC2 lifecycle using AWS services and Terraform. This allowed me to improve reliability, consistency, and efficiency.


# How the Automation Works (Big Picture)

My automation works through a simple chain of events.

1. First, EventBridge acts like a scheduler that triggers Lambda at the exact time I configure.

2. Second, the Lambda function runs my Python code, which calls the EC2 API to either start or stop the instance. 

3. Third, IAM provides the necessary permissions to allow Lambda to interact with EC2 and write logs. Finally, EC2 responds to the API calls and changes its state accordingly. Terraform serves as the tool that builds all of these AWS resources automatically.


# Project Structure and What Each File Does

I created a folder structure to organize my Terraform and Lambda code:

![alt text](<screenshots/Screenshot 2025-11-23 143853.png>)

# main.tf
This file builds all AWS resources, including IAM roles and policies, Lambda functions for starting and stopping EC2, EventBridge schedules, and the permissions needed for EventBridge to trigger Lambda. It is the core infrastructure file for this automation.

# variables.tf
This file defines the input variables needed for the project. It includes the AWS region (in my case, us-east-2) and the EC2 instance ID that Lambda should control. I pass the instance ID at runtime when applying the Terraform plan.

# outputs.tf
This file prints useful information after Terraform applies the infrastructure. It displays ARNs for the Lambda functions, EventBridge rules, and IAM roles, making it easier for me to reference or monitor them.

# start_test.py
This Python script contains the code that Lambda executes to start my EC2 instance. It uses boto3 to communicate with EC2, reads the instance ID from environment variables, and logs details to CloudWatch for debugging.

# stop_test.py
This script does the same thing as the start script, except it sends a stop command to the EC2 instance. It also prints helpful logs so I can monitor the stop process.

# start_test.zip and stop_test.zip
These ZIP files contain the Python scripts and are uploaded by Terraform to Lambda. Lambda cannot use raw .py files, so packaging them into ZIP files is required.

This folder structure kept my code clean, organized, and easy to maintain.

### 3. Ran my commands and validated my terraform

![alt text](<screenshots/Screenshot 2025-11-23 152653.png>)

![alt text](<screenshots/Screenshot 2025-11-23 152757.png>)

## 4. Validation & Confirmation in AWS Console

After applying my Terraform configuration successfully, I went into the AWS Console to confirm that everything was deployed correctly. Here’s what I validated:

Lambda Function
•	I confirmed that my Lambda function ec2_start_stop was created.
•	I verified that the correct IAM role was attached to the Lambda function.
•	I checked the Environment Variables tab to confirm my EC2 instance ID was set correctly.
•	I viewed the Monitor Logs section to ensure that the Lambda function executed without errors.


![alt text](<screenshots/Screenshot 2025-11-24 212429.png>)

![alt text](<screenshots/Screenshot 2025-11-24 211251.png>)

- CloudWatch Event Rules (EventBridge)

I confirmed that two rules were created:
  start_ec2_daily (3:15 AM trigger)
  stop_ec2_daily (9:00 PM trigger)

I verified that each rule had the correct schedule expression (cron).
I checked that each rule had a target, pointing to the Lambda function.
I confirmed that the input JSON for the rule matched the correct action (start/stop).

![alt text](<screenshots/Screenshot 2025-11-24 211137.png>)


- EC2 Instance

I verified that the EC2 instance ID I used in Terraform matches the one in Environment Variables for Lambda.
If I manually tested Lambda, I confirmed the instance started/stopped successfully.

- CloudWatch Logs

I opened CloudWatch Logs and verified that new log groups were created for the Lambda function.
I reviewed log streams to confirm the function responded correctly and completed its actions without timeout or errors.

![alt text](<screenshots/Screenshot 2025-11-24 210639.png>)

![alt text](<screenshots/Screenshot 2025-11-24 210825.png>)

![alt text](<screenshots/Screenshot 2025-11-24 210846.png>)

![alt text](<screenshots/Screenshot 2025-11-24 211217.png>)

![alt text](<screenshots/Screenshot 2025-11-24 211724.png>)

![alt text](<screenshots/Screenshot 2025-11-24 211837.png>)

## Final Summary 

In this project, I built a complete automation system that starts and stops an EC2 instance automatically. I used Terraform to deploy IAM roles, Lambda functions, EventBridge schedules, and all needed permissions. 
I wrote simple Python scripts that communicate with EC2 using boto3, and I packaged them into ZIP files for Lambda.
I also built a detailed test setup that helped me verify each part of the automation before using it. Through testing, logging, and fixing issues, I confirmed that Lambda can successfully control EC2 and that the schedules trigger Lambda as expected. The entire solution is now working end-to-end, and I fully understand how each component fits together and why it is necessary.

