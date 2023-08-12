#!/bin/bash

# Update package lists and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install essential software packages
sudo apt install -y openssh-server curl wget git htop vlc 

# Enable and start the firewall (ufw)
sudo apt install -y ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Set up fail2ban to protect against brute-force attacks
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Install Suricata
sudo apt install -y suricata

# Configure Suricata
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.original
sudo sed -i 's/ HOME_NET: "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"/ HOME_NET: "any"/' /etc/suricata/suricata.yaml
sudo sed -i 's/# - suricata-update -v/# - suricata-update -v\n    - suricata-update\n    - suricata-update update-sources/' /etc/cron.daily/suricata-update
sudo suricata-update

# Enable IPS mode in Suricata
sudo sed -i 's/#default-mode: IDS/default-mode: IPS/' /etc/suricata/suricata.yaml

# Start Suricata
sudo systemctl enable suricata
sudo systemctl start suricata

# Harden SSH configuration
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Install and configure Uncomplicated Firewall (UFW)
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable

# Install and configure automatic security updates
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Install and configure ClamAV antivirus
sudo apt install -y clamav clamav-daemon
sudo freshclam
sudo systemctl enable clamav-daemon
sudo systemctl start clamav-daemon

# Enable and start a basic intrusion detection system (IDS) - ossec-hids
sudo apt install -y ossec-hids
sudo systemctl enable ossec
sudo systemctl start ossec

# Install and configure AppArmor
sudo apt install -y apparmor apparmor-utils
sudo aa-enforce /etc/apparmor.d/*
sudo systemctl restart apparmor

# Optional: Install and configure a rootkit checker (rkhunter)
 sudo apt install -y rkhunter
 sudo rkhunter --propupd
 sudo rkhunter --check

echo "Script completed!"

