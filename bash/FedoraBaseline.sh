#!/bin/bash

# This script configures a new Fedora server install to the preferred base state.

# Update and Install required packages
sudo dnf update -y
sudo dnf install systemd-networkd cifs-utils dnf-automatic -y

# Disable NetworkManager and enable systemd-networkd
sudo systemctl disable NetworkManager
sudo systemctl enable --now systemd-networkd

# Enable systemd-resolved
sudo systemctl enable --now systemd-resolved

# Create a symbolic link for systemd-resolved
sudo rm -f /etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Add non admin user and restrict SSH from admins
# The point to this is so only this user can SSH in but cannot do anything else
# Once SSHed in - a user must su into an elevated account to perform work
# This enforces multi level auth in order to perform work
sudo adduser user
sudo passwd PASSWORD
echo "DenyGroups wheel root" | sudo tee -a /etc/ssh/sshd_config

# Configure network interface properties for ens18
cat <<EOF | sudo tee /etc/systemd/network/ens18.network
[Match]
Name=ens18

[Network]
# Change IP
Address=10.0.10.11/24
Gateway=10.0.10.254
DNS=10.0.10.254
EOF

# Mount NAS
# Change username and IP
sudo mkdir -p /home/user/.smb/
sudo touch /home/user/.smb/nas
sudo echo "username=user" > /home/user/.smb/nas
sudo echo "password=PASSWORD" >> /home/user/.smb/nas
sudo mkdir /srv/nas
sudo echo "//10.0.10.63/main       /srv/nas        cifs    uid=0,credentials=/home/user/.smb/nas,iocharset=utf8,vers=3.0,noperm 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mount -a

echo "Fedora common setup completed."

