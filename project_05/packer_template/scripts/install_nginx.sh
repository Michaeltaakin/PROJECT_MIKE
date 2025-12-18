#!/bin/bash
set -e

echo "🔹 Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y nginx ufw fail2ban

# Wait a few seconds to let systemd recognize new services
sleep 5

# ------------------------------
# 1. Verify Nginx Installation
# ------------------------------
if command -v nginx >/dev/null 2>&1 && systemctl list-unit-files | grep -q nginx.service; then
    echo "✅ Nginx installed and service exists"
else
    echo "⚠️ Nginx service not found. Reinstalling..."
    sudo apt-get install --reinstall -y nginx
    sudo systemctl daemon-reload
fi

# Enable and start Nginx safely
if systemctl list-unit-files | grep -q nginx.service; then
    sudo systemctl enable nginx
    sudo systemctl start nginx
fi

# ------------------------------
# 2. Harden Nginx
# ------------------------------
echo "🔹 Hardening Nginx configuration..."
sudo sed -i 's/# server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf || true
sudo chmod 750 /etc/nginx || true
sudo systemctl restart nginx || true

# ------------------------------
# 3. Configure Firewall (UFW)
# ------------------------------
echo "🔹 Configuring UFW firewall..."
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw --force enable

# ------------------------------
# 4. Configure Fail2Ban
# ------------------------------
echo "🔹 Setting up Fail2Ban..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# ------------------------------
# 5. Harden SSH
# ------------------------------
echo "🔹 Hardening SSH configuration..."
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config || true
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config || true

# Restart SSH safely (Ubuntu uses ssh.service, Amazon Linux uses sshd.service)
if systemctl list-units --type=service | grep -q ssh.service; then
    sudo systemctl restart ssh.service
else
    sudo systemctl restart sshd.service || true
fi

# ------------------------------
# 6. Set Web Directory Permissions
# ------------------------------
echo "🔹 Setting permissions for /var/www..."
sudo mkdir -p /var/www/html
sudo chmod -R 755 /var/www
sudo chown -R www-data:www-data /var/www

# ------------------------------
# 7. Cleanup System
# ------------------------------
echo "�� Cleaning up unused packages..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "✅ Hardened AMI setup completed successfully!"


