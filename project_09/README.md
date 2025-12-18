## Project 9 Documentation.

# Backup and Recovery of EC2 Instances with Terraform

• Description: Use Terraform to automate the creation of backups for EC2 instances using AMIs and snapshots. Set up an automatic recovery mechanism.

# Step 1: Introduction:

In this project, I automated the complete backup and recovery process for Amazon EC2 instances using Terraform. My goal was to design a reliable, repeatable infrastructure system where EC2 instances are automatically backed up daily, stored in a designated backup vault, and recovered automatically if system issues occur.
I accomplished this by deploying multiple EC2 instances, assigning them backup-specific tags, configuring AWS Backup plans, setting up an IAM role with the appropriate permissions, and implementing CloudWatch alarms for self-healing.
This documentation explains what I did, why I did it, and how each component works together.

![alt text](<screenshots/Screenshot 2025-11-14 123539.png>)


# Step 2: Deploy Multiple EC2 Instances

I created multiple EC2 instances using a count variable in Terraform.
Why: Using multiple instances allows me to test backup and recovery for more than one resource and ensures scalability.
Key Configuration:
•	AMI ID: Amazon Linux 2
•	Instance Type: t2.micro 
•	Tags:
o	Name = BackupRecoveryDemo-<index> for identification
o	Backup = true 


![alt text](<screenshots/Screenshot 2025-11-14 124254.png>)

I confirmed in the AWS EC2 Console that all instances were deployed, had the correct tags, and matched the expected count.


# Step 3:  IAM Role for AWS Backup

I created an IAM role to allow AWS Backup to access my EC2 instances.
Why: AWS Backup requires an IAM role with permissions to access EC2 instances and their tags.
Key Configuration:
•	Trust relationship for backup.amazonaws.com
•	Attached managed policy: AWSBackupServiceRolePolicyForBackup
•	This includes the required tag:GetResources permission to select instances by tags.

![alt text](<screenshots/Screenshot 2025-11-14 131123.png>)


# Step 4: Creating a Backup Vault

I created an AWS Backup Vault named ec2-backup-vault to store all recovery points (snapshots).
Why I Did It
A backup vault acts as a secure container where AWS Backup stores:
•	EC2 snapshots
•	AMI backups
•	Recovery metadata
This vault is required before applying any backup rules.

![alt text](<screenshots/Screenshot 2025-11-14 132102.png>)


# Step 5:  Creating an Automated Backup Plan

I set up a daily backup plan using aws_backup_plan. This plan defines:
•	When backups run
•	Where they are stored
•	How long they are retained

Why I Did It:
To ensure automatic daily backups without manual intervention. Automated backups reduce risk and ensure compliance.
Plan Configuration
•	Schedule: Daily at 5 AM UTC
•	Lifecycle: Delete snapshots after 30 days
•	Target Vault: ec2-backup-vault

![alt text](<screenshots/Screenshot 2025-11-14 132637.png>)


# Step 6: Select EC2 Instances by Tag

I configured AWS Backup Selection to select all EC2 instances with the tag Backup = true.
Terraform Code Snippet (AWS Provider v5+ syntax):


![alt text](<screenshots/Screenshot 2025-11-14 133659.png>)

Why I Did It:

Tag-based selection avoids manually listing resources. It allows:

1. Scaling the environment easily

2. Automatic inclusion of new instances

3. Cleaner Terraform code

Key Fix:

Initially, the selection failed due to incorrect syntax and missing permissions. I corrected:

. The selection_tag syntax

. IAM role permissions


# Step 7: CloudWatch Alarms for Auto-Recovery

I set up CloudWatch alarms for each EC2 instance to monitor system status and automatically recover any instance that fails.

![alt text](<screenshots/Screenshot 2025-11-14 134405.png>)

I created CloudWatch alarms for each EC2 instance to detect system-level failures and automatically perform recovery.

Why I Did It:

System failures (hardware issues, host issues) can make an instance unreachable. Auto-recovery:

1. Works without manual intervention

2. Reduces downtime

3. Ensures availability for production workloads

Alarm Configuration:

. Metric: StatusCheckFailed_System

. Threshold: 1

Evaluation: 2 periods of 60 seconds
Alarm Action: ec2:recover


# Step 8: Validating my Deployment 

After I ran and deployed all resources with Terraform, I logged into the AWS Management Console and manually verified each component to ensure everything was created correctly and aligned with the project design.


![alt text](<screenshots/Screenshot 2025-11-11 222014.png>)

![alt text](<screenshots/Screenshot 2025-11-11 222100.png>)

![alt text](<screenshots/Screenshot 2025-11-11 223715.png>)

I verified: 

EC2 Instances
I navigated to EC2 → Instances and confirmed:
•	The correct number of instances were deployed
•	Each instance had the proper Name tag
•	Each instance had the required backup tag (Backup = true)
•	All instances were running without errors

![alt text](<screenshots/Screenshot 2025-11-11 223938.png>)

![alt text](<screenshots/Screenshot 2025-11-11 224349.png>)

![alt text](<screenshots/Screenshot 2025-11-11 224216.png>)

![alt text](<screenshots/Screenshot 2025-11-11 224138.png>)

![alt text](<screenshots/Screenshot 2025-11-11 224111.png>)

IAM Role
Under IAM → Roles, I located the backup role I created.
I verified that:
•	The trust relationship allowed backup.amazonaws.com
•	The AWS-managed policy AWSBackupServiceRolePolicyForBackup was successfully attached

Backup Vault
In AWS Backup → Backup vaults, I confirmed:
•	The vault was created with the correct name
•	It was active and ready to receive recovery points

Backup Plan
Inside AWS Backup → Backup plans, I verified:
•	The backup plan existed with the correct name
•	The daily schedule was active
•	The plan was using the correct backup vault
•	Retention/lifecycle settings were applied properly

Backup Selection
Still under AWS Backup, I inspected the backup selections.
I confirmed that:
•	The correct selection was created
•	AWS Backup successfully included the EC2 instances based on the tag Backup = true

CloudWatch Alarms
In CloudWatch → Alarms, I checked:
•	There was one auto-recovery alarm per EC2 instance
•	Each alarm monitored the StatusCheckFailed_System metric
•	Each alarm had the automated recovery action configured correctly

![alt text](<screenshots/Screenshot 2025-11-11 230110.png>)

![alt text](<screenshots/Screenshot 2025-11-11 230044.png>)

![alt text](<screenshots/Screenshot 2025-11-11 225633.png>)

![alt text](<screenshots/Screenshot 2025-11-11 225534.png>) 

![alt text](<screenshots/Screenshot 2025-11-11 225407.png>)

![alt text](<screenshots/Screenshot 2025-11-11 225053.png>)

![alt text](<screenshots/Screenshot 2025-11-11 224842.png>)

![alt text](<screenshots/Screenshot 2025-11-11 224648.png>)

![alt text](<screenshots/Screenshot 2025-11-11 224601.png>)


After completing this validation, I confirmed that all deployed resources matched the intended architecture and were functioning correctly across EC2, IAM, AWS Backup, and CloudWatch. Everything aligned with the design and operated as expected and I destroyed my set up after confirmation.

![alt text](<screenshots/Screenshot 2025-11-11 230439.png>)

# Step 9: Final Summary

In this project, I successfully automated the full backup and recovery process for multiple EC2 instances using Terraform. I deployed multiple instances, configured AWS Backup to take daily automated snapshots, created a secure backup vault, assigned the correct IAM permissions, and implemented CloudWatch alarms for auto-recovery.
By applying tag-based backup selection, I made the system scalable and flexible, ensuring new instances can be added to the backup plan automatically. I verified all components in the AWS console, confirming that the infrastructure works exactly as intended.
This project demonstrates my ability to:
•	Build infrastructure-as-code using Terraform
•	Automate cloud backup and disaster recovery
•	Implement high-availability practices
•	Troubleshoot IAM and AWS Backup issues
•	Validate infrastructure end-to-end in AWS.
