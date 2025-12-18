## Project 8 Documentation
# Automating Server Patching with Ansible on AWS EC2 Instances

# Project Overview

In this project, I used Ansible to automate the patching and updating of EC2 instances running Amazon Linux on AWS.
The main goal was to make sure my servers stay secure, consistent, and up to date, without me having to log in and patch each one manually.
This automation helps reduce human error, saves time, and ensures that all servers follow the same patching standard.
Keeping servers updated is a key part of system administration and security.
If servers are not patched regularly, they can become vulnerable to attacks or may run outdated software.
Doing this manually is time-consuming, especially when managing multiple EC2 instances.
Using Ansible, I can:
•	Automatically apply the latest system updates.
•	Reboot servers if needed.
•	Verify that patching completed successfully.
•	Maintain consistency across all environments.

# Steps I Took

# Step 1 -- Created the EC2 Instance
I launched an Amazon Linux  EC2 instance from the AWS Console.
I made sure I could connect to it using my SSH key.
This instance acted as the target server for patching.

![alt text](<screenshots/Screenshot 2025-11-09 151913.png>)

 
# Step 2 -- Created the Project Structure
I created a clean folder structure for the project:

 ![alt text](<screenshots/Screenshot 2025-11-10 171908.png>)


Here’s what each file does:
•	inventory.ini --  lists my EC2 instances that Ansible will connect to.
•	playbook.yml -- the main Ansible playbook that performs the patching.
•	ansible.cfg -- configuration file that tells Ansible where to find the inventory and other settings.

![alt text](<screenshots/Screenshot 2025-11-10 172356.png>)


# Step 3 -- I Defined the EC2 Instance in Inventory File
I added my EC2 instance’s public IP address to inventory.ini:

![alt text](<screenshots/Screenshot 2025-11-10 172356-1.png>)

 
This tells Ansible to Connect to this EC2 instances using this username and key.

# Step 4 -- Wrote the Patching Playbook
In the playbook.yml file, I created  Ansible automation steps:

![alt text](<screenshots/Screenshot 2025-11-10 172905.png>)

 
This playbook will  updates every package to the latest version and It will reboots the server automatically if needed (for example, after a kernel update).


# Step 5 -- Ping Test to Verifying My Server Connection
Before I ran my patching playbook, I wanted to make sure Ansible could actually connect to my EC2 instance. To test that, I used Ansible’s built-in ping module.
Here’s the command I ran:
After I ran the command, Ansible connected to my EC2 instance using the private key I had set up and I got this response.


![alt text](<screenshots/Screenshot 2025-11-09 150939.png>)


Here’s what each part means:
•	ansible – this starts the Ansible command-line tool.
•	-i inventory.ini – this tells Ansible to use my inventory file, where I listed my EC2 instance details.
•	my-ec2 – this is the group name I gave my instance inside the inventory file.
•	-m ping – this tells Ansible to use the “ping” module, which checks if it can connect to the server through SSH and if Python is installed on it.
This result showed that:
•	My EC2 instance was reachable from my Ansible control node.
•	My SSH key and user credentials were correct.
•	Python was installed on the remote server (which Ansible needs to work).
The “ping: pong” message confirmed that everything was set up correctly. It meant I could move forward and run my patching playbook with confidence because Ansible was able to communicate with my EC2 instance successfully.



# Step 6 — Ran the Playbook
I executed the playbook using the ansible playbook command:

ansible-playbook playbook.yml

![alt text](<screenshots/Screenshot 2025-11-09 151501.png>)


Which means:
•	2 changes (updates and reboot)
•	0 failures
•	Everything was successful

# Step 7 -- Verified the Updates
After my playbook finished running, I verified that my EC2 instance was successfully patched.
I went to the EC2 Console, opened Instances, and clicked on the Monitoring tab.
There, I checked the CPU Utilization graph and noticed a brief CPU spike during the reboot. This confirmed that the patching and restart actually happened.
I also checked the Status Checks, and both were marked as passed after the reboot showing that my instance was healthy and back online after the updates.

![alt text](<screenshots/Screenshot 2025-11-09 153450.png>)

![alt text](<screenshots/Screenshot 2025-11-09 151913-1.png>)


# Step 8 -- Confirming the Patching Was Successful
After I ran my Ansible patching playbook and the instance rebooted, I went to the EC2 Console and opened the System Log to confirm that the patching was successful.
In the system log, I saw that the instance went through the normal boot process and completed successfully. The log ended with:
Amazon Linux 2023.8.20250818
Kernel 6.1.147-172.266.amzn2023.x86_64 on an x86_64
ip-172-31-35-222 login:

![alt text](<screenshots/Screenshot 2025-11-09 152634.png>)

 
This message confirmed that my EC2 instance had rebooted properly and was running the latest version of Amazon Linux 2023.
I also noticed that the cloud-init process finished without any errors, which means the instance completed all its startup tasks and came back online successfully.
Seeing the login prompt in the log showed that my instance was fully operational after the update and patching process.

Conclusion
This project demonstrates how I automated server patching on AWS EC2 using Ansible.
It shows I can handle cloud server management tasks, automate system updates, troubleshoot permission issues, and verify successful patching.



