packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "webapp" {
  ami_description             = "Hardened AMI with Nginx static website"
  ami_name                    = "webapp-ami-${local.timestamp}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  region                      = "us-east-2"
  source_ami                  = "ami-0cfde0ea8edd312d4" # base Ubuntu AMI
  ssh_username                = "ubuntu"
}

build {
  name    = "webapp-ami-build"
  sources = ["source.amazon-ebs.webapp"]

  # --- Step 1: Copy website files to the instance ---
  provisioner "file" {
    source      = "web"
    destination = "/home/ubuntu/"
  }

  # --- Step 2: Install Nginx, firewall, Fail2Ban, and harden the image ---
  provisioner "shell" {
    script = "scripts/install_nginx.sh"
  }

  # --- Step 3: Move web files into Nginx directory ---
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /var/www/html",
      "sudo mv /home/ubuntu/web/* /var/www/html/",
      "sudo chown -R www-data:www-data /var/www/html/",
      "sudo chmod -R 755 /var/www/html/"
    ]
  }

  # ✅ Correct way to add a post-processor in HCL2
  post-processors {
    post-processor "shell-local" {
      inline = [
        "echo '🚀 Uploading website files to S3 bucket...'",
        "aws s3 sync web/ s3://my-webapp-bucket2",
        "echo '✅ Website uploaded to S3 successfully!'"
      ]
    }
  }
}
