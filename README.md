# Server Administration Lab Setup

This repository contains a reusable `setup.sh` script that provisions a fresh CentOS Stream droplet on DigitalOcean (or any VPS).  
It installs and configures the **LAMP stack** (Linux, Apache, MariaDB, PHP), Git, and basic utilities.  

---

## 🚀 Quick Start Guide

### 1. Create a New Droplet
- Log in to [DigitalOcean](https://cloud.digitalocean.com/).
- Create a new droplet (recommend smallest plan for labs).
- Use **CentOS Stream 9** (or similar Linux distribution).
- Add your SSH key for secure login.

### 2. Log in via SSH
From your local terminal (MacBook):  
```bash
ssh root@<your_droplet_ip>
```

### 3. Run the Setup Script
Run the script directly from GitHub:
```bash
curl -s https://github.com/matilda1740/server-adminlabs/main/setup.sh | bash
```

### 4. Verify Installation

After script finishes:

Visit http://<your_droplet_ip>/info.php in a browser → PHP info page should load.

Check versions:
```bash
git --version
httpd -v
mysql --version
php -v
```
