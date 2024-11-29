#!/bin/bash

# Exit script on any error
set -e

echo "Starting Fedora upgrade process..."

# Step 1: Check for updates and upgrade current system
echo "Updating current Fedora system..."
sudo dnf update -y

# Step 2: Install dnf-plugin-system-upgrade if not installed
echo "Installing system upgrade plugin..."
sudo dnf install dnf-plugin-system-upgrade -y

# Step 3: Download Fedora packages - change to current release
echo "Downloading Fedora upgrade packages..."
sudo dnf system-upgrade download --releasever=41 -y

# Step 4: Reboot and upgrade the system
echo "Rebooting to apply Fedora upgrade..."
sudo dnf system-upgrade reboot

# Reminder in case of issues
echo "If the upgrade fails, boot into an older kernel and run: dnf system-upgrade rollback"

exit 0
