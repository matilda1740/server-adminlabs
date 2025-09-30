#!/bin/bash
# =====================================
# Server Admin Lab - Setup Script
# =====================================

echo "🚀 Starting CentOS droplet (VPS on DigitalOcean) setup..."

# --- Update system ---
sudo dnf -y update
sudo dnf -y upgrade

# --- Install essential tools ---
sudo dnf -y install git wget curl nano vim tree unzip

# --- Configure Git (replace with your details) ---
git config --global user.name "Gitonga Matilda Mwendwa"
git config --global user.email "matilda1740@gmail.com"

 --- Install Apache (httpd) ---
sudo dnf -y install httpd
sudo systemctl enable --now httpd

# --- Install MariaDB (MySQL fork) ---
sudo dnf -y install mariadb-server mariadb
sudo systemctl enable --now mariadb

# Secure MariaDB installation (manual interaction)
sudo mysql_secure_installation

# --- Install PHP (for LAMP) ---
sudo dnf -y install php php-mysqlnd php-cli

# Restart Apache to load PHP
sudo systemctl restart httpd

# --- Create Test PHP File ---
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# --- Firewall (if enabled) ---
# sudo firewall-cmd --permanent --add-service=http
# sudo firewall-cmd --permanent --add-service=https
# sudo firewall-cmd --reload

# --- Confirm versions ---
echo "✅ Installed versions:"
httpd -v
mysql --version
php -v
git --version

echo "🎉 Setup complete! Access test page at: http://<your_droplet_ip>/info.php"

