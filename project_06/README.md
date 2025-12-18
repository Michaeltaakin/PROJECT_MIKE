##  Automated S3 Static Website Hosting with Terraform 

# 1. Project Description
In this project, I used Terraform to automate the creation of an Amazon S3 bucket and configure it for static website hosting.
My goal was to deploy a simple website using HTML files (index.html and error.html) without needing to run or manage any servers.
By the end of this project, I was able to automatically create the S3 bucket, upload my website files, make the site publicly accessible, and get a working website URL all through Terraform.



# 2. Project Objectives

•	Automate S3 bucket creation using Terraform.
•	Configure the bucket for static website hosting.
•	Upload website files (index.html, error.html) automatically.
•	Set the correct permissions to make the website publicly accessible.
•	Output the website endpoint after deployment.


# Terraform Files Overview
	
main.tf -- Contains the main configuration for AWS provider, S3 bucket, website setup, and object uploads.
variables.tf -- Stores input variables such as AWS region and bucket name.
outputs.tf   --	Displays the website endpoint URL after deployment.
index.html & error.html	-- Website content files that will be hosted on S3.

![alt text](<screenshots/Screenshot 2025-11-02 165414.png>)


## How I Built the Project:


# Step 1: Provider Configuration
First, I defined the AWS provider in Terraform so it could connect to my AWS account and create resources in my chosen region.

# Step 2: Creating the S3 Bucket
Next, I used Terraform to create a new S3 bucket. I gave it a unique name stored in a variable.

# Step 3: Configuring Static Website Hosting
I then enabled website hosting for the S3 bucket and defined the main index and error pages which tells AWS to use index.html as the homepage and error.html when a page isn’t found.

# Step 4: Allowing Public Access
By default, AWS blocks public access to S3 buckets. To make my website public, I had to disable the “Block Public Access” setting for this bucket and then add a bucket policy.
I did that using these Terraform resources:

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls        = false
  block_public_policy      = false
  ignore_public_acls       = false
  restrict_public_buckets  = false
}
Then I added a bucket policy that allows anyone to read objects from my bucket:

hcl
Copy code
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}
This made the files in my bucket publicly readable so that the website could be viewed by anyone.


# Step 5: Uploading Website Files
Once the bucket and policy were in place, I configured Terraform to automatically upload my index.html and error.html files to the bucket.

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}
After running terraform apply, both files were uploaded automatically to the S3 bucket.


# Step 6: Outputting the Website URL
Finally, I added an output block so Terraform would print the website’s public endpoint URL once the deployment was complete. When the deployment finished, Terraform displayed the URL where my static website could be accessed.

![alt text](<screenshots/Screenshot 2025-11-02 165521.png>)


## How the Automation Works

When I ran terraform apply, Terraform:

1.	Authenticated to AWS using my credentials.
2.	Created a new S3 bucket in my region.
3.	Configured the bucket for static website hosting.
4.	Disabled the block on public access and applied a bucket policy for read access.
5.	Uploaded my index.html and error.html files automatically.
6.	Printed out the public website URL as an output.

All these steps happened automatically, without me having to manually create or configure anything in the AWS Console.

## My Deployment Output
After applying the configuration, Terraform displayed:


![alt text](<screenshots/Screenshot 2025-11-02 165659.png>) 

![alt text](<screenshots/Screenshot 2025-11-02 165750.png>)
      
![alt text](<screenshots/Screenshot 2025-11-02 165731.png>)

I copied this link and pasted it into my browser. My static website loaded successfully, showing the contents of my index.html file.

![alt text](<screenshots/Screenshot 2025-11-02 165811.png>)

![alt text](<screenshots/Screenshot 2025-11-02 165849.png>)
   
![alt text](<screenshots/Screenshot 2025-11-02 165837.png>)

![alt text](<screenshots/Screenshot 2025-11-02 165940.png>)


# Cleanup Process

After testing my website, I destroyed all the resources to avoid unnecessary AWS charges by running:
terraform destroy -auto-approve
This removed the S3 bucket and all its contents automatically.

![alt text](<screenshots/Screenshot 2025-11-02 171221.png>)


## What I Learned

Through this project, I learned:

•	How to use Terraform to automate AWS infrastructure setup.
•	How to configure S3 for static website hosting.
•	How S3 bucket policies work for granting public access.
•	Why ACLs are deprecated in modern S3 configurations.
•	How Terraform manages infrastructure in a reusable and consistent way.

# Conclusion

This project gave me hands-on experience using Terraform to automate an AWS S3 static website deployment.
Instead of manually creating a bucket and uploading files, I used code to handle everything from setup to permissions to uploads.
The final result was a fully automated, reusable static website hosting solution that can be redeployed anytime by simply running terraform apply.



















 


  


    


     


       



