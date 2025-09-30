#!/bin/bash
# =======================================================
# Server Admin Lab - Setup Script
# Extended with Nginx Reverse Proxy + MariaDB Security
# =======================================================

echo "🚀 Starting CentOS droplet (VPS on DigitalOcean) setup..."

# --- Update system ---
echo "🔄 Updating system packages..."
sudo dnf -y update && sudo dnf -y upgrade

# --- Install essential tools ---
echo "📦 Installing essential tools (git, curl, vim, nano, etc.)..."
sudo dnf -y install git wget curl nano vim tree unzip

# --- Configure Git ---
echo "🛠️ Configuring Git global identity..."
git config --global user.name "Gitonga Matilda Mwendwa"
git config --global user.email "matilda1740@gmail.com"

# --- Install Apache (httpd), PHP, MariaDB ---
echo "📦 Installing Apache (httpd), PHP, and MariaDB..."
sudo dnf -y install httpd mariadb-server mariadb php php-mysqlnd php-cli

echo "⚙️ Enabling and starting Apache and MariaDB..."
sudo systemctl enable --now httpd
sudo systemctl enable --now mariadb

# --- Move Apache to port 8080  ---
echo "🔧 Reconfiguring Apache to run on port 8080..."
sudo sed -i 's/^Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
sudo systemctl restart httpd

# --- Install Nginx ---
echo "📦 Installing Nginx..."
sudo dnf -y install nginx
echo "⚙️ Enabling and starting Nginx..."
sudo systemctl enable --now nginx

# --- Configure Nginx Reverse Proxy ---
echo "📝 Creating Nginx reverse proxy configuration..."
NGINX_CONF="/etc/nginx/conf.d/reverse-proxy.conf"

sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80 default_server;
    server_name _;

    root /var/www/html;

    # Serve static files directly
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|html)$ {
        expires 30d;
        access_log off;
    }

    # Forward PHP requests to Apache
    location ~ \.php$ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Default: send everything else to Apache
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

echo "🔎 Testing Nginx configuration..."
sudo nginx -t && sudo systemctl reload nginx

# --- Create Test Files ---
echo "📝 Creating test files in /var/www/html..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
echo "<h1>Hello from Nginx (static)</h1>" | sudo tee /var/www/html/index.html

# --- Secure MariaDB Installation (Interactive) ---
echo "⚠️ Now securing MariaDB..."
echo "👉 You will be asked to set a root password, remove anonymous users,"
echo "👉 disable remote root login, remove test DB, and reload privileges."
echo "👉 This step is INTERACTIVE for safety."
sudo mysql_secure_installation

# --- Confirm versions ---
echo "✅ Installed versions:"
httpd -v
mysql --version
php -v
git --version

# --- Final Output ---
echo "====================================="
echo "🎉 Setup complete!"
echo "👉 Visit http://<your_droplet_ip>/index.html (served by Nginx)"
echo "👉 Visit http://<your_droplet_ip>/info.php (processed by Apache+PHP via Nginx)"
echo "👉 MariaDB has been installed. Root password set via secure installation."
echo "====================================="




