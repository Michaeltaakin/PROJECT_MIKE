## Project Documentation: Building a Custom VPC, Subnets, Security Groups, and EC2 Instances Using Terraform

In this project, I used Terraform to design and deploy a complete AWS network environment. Instead of working with the default VPC, I created a fully customized setup that includes public and private subnets, routing, security controls, and EC2 instances distributed across multiple Availability Zones.

## What I implemented
# 1. Setting up Terraform and AWS Provider

First, I configured Terraform to connect to AWS and specified the region where resources would be deployed. I also used variables for values such as the AMI, instance type, and number of EC2 instances, allowing these settings to be updated easily without modifying the main configuration. This approach makes the setup flexible and easy to maintain.

![alt text](<screenshots/Screenshot 2025-12-11 120543.png>)

# 2. Created a Custom VPC

I deployed a custom VPC with the CIDR block 10.0.0.0/16 and enabled DNS support and hostnames.
This VPC serves as the foundation for all network components.

![alt text](<screenshots/Screenshot 2025-12-10 212923.png>)

# 3. Built Public Subnets Across Two AZs

I created two public subnets in separate Availability Zones (us-east-2a and us-east-2b) to ensure high availability. Both subnets were configured to automatically assign public IP addresses to any instances launched within them.   

![alt text](<screenshots/Screenshot 2025-12-10 213340.png>)

# 4. Built a Private Subnet
I created a private subnet in us-east-2a where instances do not receive public IP addresses, making it suitable for backend or internal workloads that should not be directly accessible from the internet.

![alt text](<screenshots/Screenshot 2025-12-10 213340.png>)

# 5. Created an Internet Gateway

To let my public subnets reach the internet, I attached an internet gateway to the VPC.
This is basically the “doorway” between my VPC and the internet.

![alt text](<screenshots/Screenshot 2025-12-10 213310.png>)

# 6. Created a Public Route Table

I created a route table and added a route that sends all outbound traffic (0.0.0.0/0) to the internet gateway.
Then I associated both public subnets with this route table.
This is what officially makes them “public.” 

![alt text](<screenshots/Screenshot 2025-12-10 213419.png>)
![alt text](<screenshots/Screenshot 2025-12-10 212923.png>)

# 7. Built a Security Group for SSH + HTTP

I created a security group that allows SSH (port 22), HTTP (port 80), and all outbound traffic. This security group is attached to all EC2 instances, both in public and private subnets. For the private subnet, the route table does not include a route to an Internet Gateway. As a result, any traffic from the internet has no path to reach these instances. Even though the security group allows ports like 22 and 80, the instances remain protected because the route table prevents external access.

![alt text](<screenshots/Screenshot 2025-12-10 213100.png>)

# 8. EC2 Instances in Public Subnets

I deployed two EC2 instances in the public subnets using the count function.
Each instance goes into a different public subnet for resiliency.
By deploying instances across multiple subnets, I added redundancy (multiple instances) which improves the overall resiliency of my setup.
By spreading instances across different subnets and AZs:

If one Availability Zone goes down
- The other instance in the other AZ is still running.

If one subnet has issues
- The other subnet still works.

This increases high availability and reduces downtime.

![alt text](<screenshots/Screenshot 2025-12-10 212527.png>)

# 8. EC2 Instance in Private Subnet

I deployed an additional EC2 instance in the private subnet. This instance does not receive a public IP and can only be accessed internally within the VPC, for example, through a bastion host or AWS Systems Manager. It simulates a backend server, such as a database or other internal service.

This simulates a backend server such as a database or internal service.

![alt text](<screenshots/Screenshot 2025-12-10 212527.png>)

# 9. Added Output Values

To help verify and reference the environment, I added outputs for:

The VPC ID
Public IP addresses of the public EC2 instances
The Availability Zones where the public instances were deployed
These outputs make validation straightforward after running terraform apply.

![alt text](<screenshots/Screenshot 2025-12-10 213754.png>)

![alt text](<screenshots/Screenshot 2025-12-10 213645.png>)

# 10. Final verification from my AWS concole
By the end of the project, I had:

Fully custom VPC,
Two public subnets in different AZs,
One private subnet,
internet gateway and routing,
security group,
Public EC2 instances,,
private EC2 instance,
Useful Terraform outputs.

Everything was automated through Terraform, which makes it easy to destroy and rebuild anytime with a single command.

![alt text](<screenshots/Screenshot 2025-12-10 214047.png>)

## Conclusion

In this project, I designed a production-ready AWS network architecture using Terraform, which enhanced my skills in VPC design, subnet planning, routing configuration, security groups, and automated EC2 provisioning. It also gave me hands-on experience applying best practices for building secure, scalable, and efficient cloud environments.





















