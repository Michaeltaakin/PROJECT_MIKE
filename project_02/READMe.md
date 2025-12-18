## Deploying Nginx on EC2 Using Ansible

Project Overview

In this project, I automated the deployment of an Nginx web server on multiple AWS EC2 instances using Ansible.
Instead of logging in to each server to install Nginx and set up a web page, I used Ansible to automate  with just one command.
The purpose of this project was to demonstrate how automation can save time, reduce errors, ensure consistent server configuration and and the ability to manage multiple servers simultaneously.

# Tools I Used

AWS EC2 – Hosts for the web servers

Ansible – Automation tool for configuration management

Amazon Linux 2 – Operating system for EC2 instances

SSH Key Pair – For secure access to EC2 instances

Custom HTML File – Web page content to deploy



# NEXT STEP I TOOK WAS CREATING ANSIBLE FILES 

I created and worked with two main Ansible files in this project:

1.	inventory.ini – this file contains my server details (IP addresses).
2.	nginx.yml – this is the main playbook file that tells Ansible what to do.

![alt text](<screenshots/Screenshot 2025-10-16 181735-1.png>)
![alt text](<Screenshot 2025-10-16 181735.png>)

# nginx.yml (The Ansible Playbook)

![alt text](<screenshots/Screenshot 2025-10-16 182652.png>) 

## Ansible Playbook Step-by-Step Explanation

# Playbook Header

hosts: webservers - Run tasks on all servers in the webservers group.

become: yes - Execute tasks with root privileges.

# Update System Packages

Ensures all installed packages are updated to the latest version.

Uses yum package manager.

Install Nginx
Installs Nginx if it’s not already present on the server.
Start and Enable Nginx
Starts the Nginx service immediately.
Enables it to start automatically on system boot.
Deploy Custom Web Page
Copies the local index.html file to the Nginx default web root.
Replaces the default Nginx landing page.


## This part shows how I executed the playbook.

Step 1: Test Connection (Ping)
Before running the full playbook, I checked that Ansible could connect to my EC2 instances.

![alt text](<screenshots/Screenshot 2025-10-16 183326.png>)

![alt text](<screenshots/Screenshot 2025-10-16 183517.png>)

![alt text](<screenshots/Screenshot 2025-10-16 183828.png>)


## NEXT STEP: Ran the Playbook

Once the connection worked, I ran the main playbook using the command below:
ansible-playbook -i inventory.ini nginx.yml

## Verifying in Browser

After the playbook finished running, I went to the AWS Console, copied each instance’s Public IP, and opened it in a browser:

![alt text](<screenshots/Screenshot 2025-10-16 182243.png>) 


## Validation

After running the playbook, I verified:

Package Updates - All system packages were up-to-date.

Nginx Installation - Nginx was installed and running.

Service Status - Nginx automatically starts on reboot.

Custom Web Page - Accessible via the public IP of each EC2 instance in a browser.

![alt text](<screenshots/Screenshot 2025-10-16 185205.png>) 

![alt text](<screenshots/Screenshot 2025-10-16 185056.png>) 



## Conclusion

This project allowed me to automate the deployment of a production-style web server environment in AWS using Ansible.

  











