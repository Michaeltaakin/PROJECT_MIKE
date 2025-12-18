## Load Balancer and Web Server Configuration with ELB and Ansible 

• Description: Set up an AWS Elastic Load Balancer (ELB) to distribute traffic across multiple EC2 instances running a web server.

This project demonstrates how I was able to set up an AWS Elastic Load Balancer (ELB) using Terraform to distribute web traffic across two EC2 instances running in different subnets (availability zones).
The ELB improves availability and reliability by automatically routing incoming requests to healthy instances.
In this setup:
•	Terraform was used for Infrastructure as Code (IaC) to automate AWS resource creation.
•	Ansible was used to install and configure the web server (Nginx) on the instances.
•	AWS Services: VPC, Subnets, Security Groups, EC2, ELB.


## STEP 1:

I used Terraform to create all AWS resources automatically using 3 main files created inside my terraform project directory:
•	main.tf
•	variables.tf
•	outputs.tf

1. main.tf - This is the main configuration file where all AWS resources are defined.

- 	Provider Block - Tells Terraform to use the AWS provider and defines the region where all resources will be created (e.g., us-east-1).

-	VPC - Creates a Virtual Private Cloud (VPC) — a secure, isolated network where all AWS resources (EC2, subnets, ELB) will live.    
              10.0.0.0/16 defines the IP address range.
-	Subnets - Creates two public subnets, one in each availability zone (for example, us-east-2a and us-east-2b).
This ensures high availability (e.g, if one zone goes down, the other stays active).

-	Internet Gateway - Allows resources in the VPC (like EC2 instances) to connect to the internet.

-	Route Table and Associations - Creates a public route table that sends all internet-bound traffic
 (0.0.0.0/0) through the Internet Gateway.
The associations attach this route table to both subnets, making them public.

-	Security Group - Purpose:
Ingress rules allow: Port 80 for HTTP traffic , Port 22 for SSH access.
 Egress allows all outgoing connections. 
This makes the web server accessible to the internet.

-	EC2 Instances - Creates two EC2 instances automatically using a count.
Each instance is launched in a different subnet for redundancy.

-	Elastic Load Balancer (Classic ELB) -  The ELB distributes incoming traffic to both EC2 instances. Health checks ensure the ELB only sends traffic to healthy instances (those responding to HTTP on port 80). e.g, If one instance fails, traffic automatically routes to the other.


2. variables.tf  - Parameter Inputs
This file makes the configuration flexible.


3. outputs.tf  - Display Information After Deployment
After running Terraform, this shows the Load Balancer’s public DNS to access my web app.




## Step 2: Initialize and Deploy Terraform

I ran these commands in each steps for deployment:

terraform init -  downloads AWS provider plugins
terraform plan - previews what will be created
terraform apply - actually creates all resources

![alt text](<screenshots/Screenshot 2025-10-10 103857.png>) 

![alt text](<screenshots/Screenshot 2025-10-10 103950.png>)

![alt text](<screenshots/Screenshot 2025-10-10 104105.png>)

After running terraform apply, I verified in the AWS Management Console that two EC2 instances were successfully created.
Both instances are running under the specified VPC and subnets. Each instance is in a separate availability zone (us-east-2a and us-east-2b), confirming that the infrastructure supports high availability. 

![alt text](<screenshots/Screenshot 2025-10-10 104434.png>)

![alt text](<screenshots/Screenshot 2025-10-11 175022.png>) 

![alt text](<screenshots/Screenshot 2025-10-11 162913.png>)


## STEP 3 :  Configuration of EC2 Instances with Ansible

EC2 Server Inventory:

elb_dns_name	web-elb-57422697.us-east-2.elb.amazonaws.com	
The public DNS endpoint of the Elastic Load Balancer. Users access the web application through this address.

instance_public_ips	  ["18.116.23.145","3.133.184.138"]	

These are the public IPs of the two EC2 instances running the web server. Each resides in a separate subnet for redundancy.


After EC2s are created, I used Ansible to install and configure Nginx automatically.
I created 2 Ansible files to automate the configuration of the web servers after they were provisioned by Terraform:

1. Inventory file (hosts.ini) -  The inventory file tells Ansible which servers to connect to and configure.
It lists the IP addresses (or DNS names) of the EC2 instances created by Terraform.
2. Playbook file (nginx.yml) - This file defines the automation tasks Ansible should perform on each EC2 instance.
The goal is to install and configure Nginx as a web server automatically.

## Created Ansible Playbook for Web Servers

![alt text](<screenshots/Screenshot 2025-12-12 121916.png>)

# Step-by-Step Explanation for Ansible playbook

# Playbook Header

hosts: webservers - Apply tasks to all servers in the webservers group
become: yes - Run tasks with root privileges

# Update Packages

yum: name="*" - Updates all installed packages to the latest version
Install Nginx
Ensures Nginx web server is installed
Start and Enable Nginx
Starts Nginx immediately
Enables automatic startup on system boot
Deploy Custom Web Page
Copies index.html to the Nginx web root
Replaces the default landing page.

## Command executed

I executed the playbook command using :  ansible webservers -i inventory.ini -m ping
ansible-playbook -i inventory.ini nginx.yml


![alt text](<screenshots/Screenshot 2025-10-11 175644.png>)

![alt text](<screenshots/Screenshot 2025-10-11 175613.png>)

![alt text](<screenshots/Screenshot 2025-10-11 175335.png>)
 
After it ran successfully:

Ansible connects to each EC2 instance,  Installs and starts Nginx.
I verified the setup by visiting each instance’s public IP (and the Load Balancer DNS name in a browser) which gave me the instance IP browser and Nginx welcome page.

![alt text](<screenshots/Screenshot 2025-10-16 185056.png>)

![alt text](<screenshots/Screenshot 2025-10-11 175335.png>)


## Validation

After deployment:

Verified Nginx was installed and running on all EC2 instances.
Accessed ELB DNS → Confirmed the custom web page was served.
Simulated an instance failure → Traffic continued to flow to healthy instances.

## Learning Outcomes

I Learned how to automate web server deployment with Ansible.
Gained experience configuring AWS ELB to distribute traffic across multiple EC2 instances.
Understood high availability and load balancing concepts.
Practiced Infrastructure as Code principles with Ansible and optional Terraform integration.

## Conclusion

This project allowed me to create a scalable, highly available web architecture using Ansible and AWS ELB.
I gained hands-on experience with automation, load balancing, and health checks, which are critical for production-grade web applications.
