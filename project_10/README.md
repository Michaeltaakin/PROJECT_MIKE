## Project 10 Documentation.

## IAM Role and Security Policy Automation with Terraform

Description: Use Terraform to automate the creation of IAM roles, policies, and permissions for EC2, S3, and CloudWatch.

Project Overview
In this project, I automated the creation of an IAM Role, IAM Policies, and policy attachments using Terraform. The purpose was to give my EC2 instance secure access to:
•	An existing S3 bucket (not created by Terraform)
•	CloudWatch Logs and Metrics
I used Terraform because it allows me to manage IAM resources as code, avoid human errors, and keep everything repeatable.


Project Objectives
•	Automate the creation of IAM roles for EC2 instances.
•	Define custom IAM policies for S3 and CloudWatch access.
•	Attach the policies to the IAM role.
•	Create an instance profile for EC2 to assume the role automatically.
•	Use Terraform to ensure repeatable, auditable deployments.

1. Project Approach
I structured my Terraform project into four main files:

![alt text](<screenshots/Screenshot 2025-11-19 193715.png>)

# main.tf
Contains the resources that Terraform creates:

-IAM role for EC2 with a trust policy.
-Instance profile for EC2 to assume the role.
-Custom policies for S3 and CloudWatch.
-Attachments linking policies to the role.

# variables.tf
Stores input variables for the project:

-AWS region.
-IAM role name.
-S3 bucket ARN.

Variables make the project flexible and reusable without editing main.tf.

# outputs.tf
Displays key information after Terraform deploys resources:

-EC2 IAM role ARN.
-Instance profile name.
-Outputs help confirm the deployment and reference resources in other Terraform configurations or in AWS console.

# provider.tf
Configures Terraform to connect to AWS:

-Sets the AWS provider.
-Specifies the AWS region using variables.
-This ensures Terraform creates resources in the correct AWS account and region.

## Step 2: What I Implemented 
 
Provider Configuration:
I configured Terraform to use the AWS provider and operate in my selected AWS region.
This ensures Terraform knows where and how to create resources in my AWS account.
 IAM Role for EC2
I created an IAM role that EC2 instances can assume.
The role includes a trust policy explicitly allowing the EC2 service to use the role via sts:AssumeRole.

S3 Access Policy
Since EC2 needed access to an existing S3 bucket, I created a policy granting:
•	s3:ListBucket
•	s3:GetObject
•	s3:PutObject
The policy is attached to the ARN of my existing bucket, ensuring secure access.

CloudWatch Logging Policy
To allow EC2 to send logs and metrics to CloudWatch, I created a policy that permits:
•	Creating log groups and log streams
•	Putting log events
•	Publishing custom metrics

![alt text](<screenshots/Screenshot 2025-11-20 125950.png>)

This enables EC2 to report monitoring data to CloudWatch.

Policy Attachments
Both the S3 and CloudWatch policies were attached to the IAM role using Terraform, giving the role all necessary permissions.

![alt text](<screenshots/Screenshot 2025-11-20 125501.png>)

Instance Profile
I created an instance profile for the IAM role.
The instance profile allows EC2 to assume the IAM role automatically when it starts.
Without the instance profile, EC2 cannot use the role.

Variables and Outputs
I defined variables to make the configuration flexible and reusable, including AWS region, role name, and S3 bucket ARN.
I also defined outputs to easily retrieve the IAM role ARN, instance profile name, and policy ARNs.
These outputs simplify debugging, verification, and integration with other resources.


## Step 3: Validating my Deployment 

After I ran and deployed all resources with Terraform, I logged into the AWS Management Console and manually verified each component to ensure everything was created correctly and aligned with the project design.

![alt text](<screenshots/Screenshot 2025-11-19 194518.png>)

![alt text](<screenshots/Screenshot 2025-11-19 194537.png>)

## Step 4: Validation in AWS Console

After running terraform apply, I manually confirmed the deployment:
•	IAM Role: Role exists (tf-ec2-role) with trust policy for EC2.
•	Policies: S3 and CloudWatch policies attached correctly, with intended permissions.
•	Instance Profile: Exists, linked to the role, and successfully attached to EC2.
•	EC2 Access Test:
-	Listed objects in S3 (aws s3 ls s3:// my-webapp-bucket2) — successful.
-	Sent CloudWatch metrics and logs  successful.

This confirmed all resources were deployed correctly, and the EC2 instance could securely access AWS services.

![alt text](<screenshots/Screenshot 2025-11-19 194956.png>)

![alt text](<screenshots/Screenshot 2025-11-19 195124.png>)

![alt text](<screenshots/Screenshot 2025-11-19 195317.png>)

![alt text](<screenshots/Screenshot 2025-11-19 195409.png>)

![alt text](<screenshots/Screenshot 2025-11-19 195838.png>)

![alt text](<screenshots/Screenshot 2025-11-19 200130.png>)


## Step 5: Final Summary

In this project, I used Terraform to automate the creation of a secure AWS environment that includes an S3 bucket, an IAM role, a least-privilege IAM policy, an instance profile, and an EC2 instance. By automating these components, I eliminated the need for manual IAM configuration and ensured that the EC2 instance can safely access the S3 bucket and write logs to CloudWatch without using any static access keys. The entire setup follows AWS security best practices, uses temporary credentials, blocks public access to the S3 bucket, and fully leverages Infrastructure-as-Code.

