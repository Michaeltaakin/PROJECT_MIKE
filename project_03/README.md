## Project Documentation: Infrastructure as Code (IaC) for Auto Scaling EC2 with Terraform


In this project, I automated the deployment of a custom AWS infrastructure using Terraform.
My goal was to create a custom VPC, subnet, security group, launch template, and an Auto Scaling Group (ASG) that automatically manages EC2 instances.
This setup allows EC2 instances to scale up or down automatically based on defined scaling policies, ensuring high availability and performance while reducing manual effort.

## Tools & Services Used

Terraform – Infrastructure as Code (IaC) tool

AWS EC2 – Virtual machines for web servers

AWS VPC – Custom network environment

Auto Scaling Group (ASG) – Automatically manage EC2 instances

Security Groups – Firewall rules for HTTP & SSH access

Amazon Linux 2 AMI – Base image for EC2 instances

SSH Key Pair – Secure login to EC2 instances


## FILE STRUCTURING

The next steps I did was creating a file structure to make Terraform configuration split into several files for clarity and modularity:

provider.tf -  This file defines the cloud provider (AWS) and the region where resources are deployed.

variables.tf - This file holds variable definitions  on placeholders for values such as region, VPC CIDR, AMI, key pair, etc.
 Using variables makes the Terraform code reusable and scalable.
For example, if I want to deploy in another region, I can simply change the region value here.

main.tf -  This defines the main AWS infrastructure.

output.tf - This file displays useful output information after Terraform deployment.

terraform.tfstate -  This is an automatically generated file that Terraform uses to track the real-world state of your AWS resources.
Purpose:
•	It acts as Terraform’s “memory” -  keeping track of what has been deployed.
•	It allows Terraform to know what to change, destroy, or update next time you run terraform apply.



## DEPLOYMENT STEPS 

To deploy this infrastructure, I Applied using my Terraform commands:

terraform init
terraform validate
terraform plan
terraform apply 

![alt text](<screenshots/Screenshot 2025-10-28 112050.png>)

![alt text](<screenshots/Screenshot 2025-10-28 112734.png>) 

![alt text](<screenshots/Screenshot 2025-10-28 112950.png>) 



After getting a successful deployment, I verified my Results on AWS Console.
I confirmed the following from my console:

•	My VPC and subnet were successfully created.
•	A security group allowing HTTP and SSH traffic existed.
•	An Auto Scaling Group was running with one EC2 instance.
•	The scaling policy was available for manual or future automatic scaling.


![alt text](<screenshots/Screenshot 2025-10-28 113155.png>)

![alt text](<screenshots/Screenshot 2025-10-28 113247.png>)
  
![alt text](<screenshots/Screenshot 2025-10-28 113441.png>)

![alt text](<screenshots/Screenshot 2025-10-28 113505.png>)

![alt text](<screenshots/Screenshot 2025-10-28 113756.png>)

![alt text](<screenshots/Screenshot 2025-10-28 114220.png>)

![alt text](<screenshots/Screenshot 2025-10-28 114742.png>)



## Conclusion

Through this project, I successfully automated an entire AWS infrastructure using Terraform.
I learned how each component from VPC to Auto Scaling Group fits together to create a self-scaling environment.
This project demonstrates the power of Infrastructure as Code (IaC), providing:
•	Consistent deployments,
•	Easy scalability, and
•	Simplified management of complex cloud infrastructure.

