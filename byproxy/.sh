#!/bin/bash

# Check if the script is running with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root"
  exit 1
fi

# Check if the operating system is supported (Arch Linux or Debian)
if [ -f /etc/arch-release ]; then
  # Arch Linux
  pacman -Sy --noconfirm nmap
elif [ -f /etc/debian_version ]; then
  # Debian
  apt-get update
  apt-get install -y nmap
else
  echo "Unsupported operating system"
  exit 1
fi

# Create a directory to store the results
mkdir -p /var/proxy_scan

# Function to scan for open proxies using Nmap
scan_proxies() {
  local output_file="/var/proxy_scan/proxy_scan_$(date +%Y%m%d%H%M%S).txt"
  nmap -p 8080,3128,1080 --open --script http-open-proxy.nse -oN $output_file
}

# Run the proxy scanning every 2 hours
while true; do
  scan_proxies
  sleep 2h
done
