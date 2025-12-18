## Project Documentation: Building and Hosting a Static Website using Packer, AMI, and S3


# Overview
In this project, I automated the process of building a custom Amazon Machine Image (AMI) that contains a hardened Nginx web server with my website files using Packer.
After successfully building the AMI, I uploaded my static website files to Amazon S3 and configured S3 Static Website Hosting manually through the AWS Console to make the website live and accessible on the internet.

## 1. Setting Up Packer

Packer is an automation tool used to create custom machine images (like Amazon AMIs).
Instead of manually setting up a server, I used Packer to automatically:
•	Launch a temporary EC2 instance
•	Install Nginx and security tools
•	Copy my website files
•	Create a reusable AMI image
This image can be used to launch pre-configured EC2 instances in the future.


## 2. Project Folder Structure

Below is here is  how I organized my Packer project files:

![alt text](<screenshots/Screenshot 2025-10-22 203433-1.png>)

•	scripts/install_nginx.sh - Bash script to install and configure Nginx. This script installs Nginx, configures basic security, and prepares the server.

•	web/ Contains my static website files


•	packer-template.pkr.hcl - My main Packer configuration file

## 3. Building the Image with Packer

I ran the following command in my project directory:
packer init .
packer validate packer-template.pkr.hcl
packer build packer-template.pkr.hcl

![alt text](<screenshots/Screenshot 2025-10-23 144233.png>)

What Happens Here:

•	Packer launches a temporary EC2 instance using the Ubuntu base AMI.
•	It installs Nginx and copies my web files.
•	Once setup is complete, Packer saves that configuration as a new custom AMI.
•	Then it uploads my web files to S3 automatically.

When the build completed successfully, I saw a message like this:

![alt text](<screenshots/Screenshot 2025-10-28 222458.png>)

![alt text](<screenshots/Screenshot 2025-10-28 222458.png>)


That AMI is now available in my AWS account under EC2 - AMIs.

![alt text](<screenshots/Screenshot 2025-10-28 222548.png>)


## 4. The AMI I Built

The AMI I created contains:
•	Ubuntu OS
•	Nginx pre-installed and enabled
•	My static website files in /var/www/html
•	Basic security (UFW and Fail2Ban)

![alt text](<screenshots/Screenshot 2025-10-28 223106.png>) 

![alt text](<screenshots/Screenshot 2025-10-28 223221.png>)


Purpose:
This AMI is reusable.
If I want to deploy a new EC2 instance later, I can select this AMI — it will launch a ready-to-run web server immediately.



## 5. Uploading Website Files to S3
As part of the Packer process, my files in the web/ folder were automatically uploaded to S3 using:
aws s3 sync web/ s3://my-webapp-bucket2


However, I also manually verified this process from the AWS Console to ensure the files were uploaded correctly.

## 6. Setting Up S3 Website Hosting (Manual via AWS Console)
Since I didn’t use Terraform for this part, I configured the hosting manually.

1.	Created a new S3 bucket

Name: my-webapp-bucket2
Region: us-east-2
Unchecked “Block all public access” so my website can be publicly accessible.

2.	Uploaded website files

I uploaded my index.html and other files manually (and confirmed upload from Packer worked too).
3.	Set Bucket Policy for Public Access

Went to Permissions - Bucket policy
Added this policy:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::my-webapp-bucket2/*"]
    }
  ]
}


## 7. Enabled Static Website Hosting

•	Went to Properties - Static website hosting
•	Selected Enable
•	Entered:
	Index document: index.html
•	Saved changes.


## 8. Website URL

After enabling hosting, AWS provided a public endpoint for my site:
http://my-webapp-bucket2.s3-website-us-east-2.amazonaws.com

When I opened that link in my browser, my static website loaded successfully

![alt text](<screenshots/Screenshot 2025-10-28 224812.png>) 



## Conclusion

Through this project, I successfully automated the process of building and deploying a static website using AWS tools. By leveraging Packer, I was able to automatically create a custom AMI that includes Nginx and all necessary configurations, eliminating the need for manual server setup. Using Amazon S3, I hosted my website efficiently without maintaining a running EC2 instance, demonstrating the flexibility of AWS for static web hosting.
Overall, this project showcases how automation and cloud infrastructure can streamline web deployment workflows. The AMI I created is reusable and can serve as a foundation for future EC2-based deployments or scaling needs.

