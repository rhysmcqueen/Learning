#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx


# Get Private IP BLock
# PRIVATE_IP_CIDR=$(ip -4 addr show ens5 | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+')
# PRIVATE_IP=$(echo $PRIVATE_IP_CIDR | cut -d/ -f1)
# PRIVATE_IP_32="${PRIVATE_IP}/32"
#Tailscale


curl -fsSL https://tailscale.com/install.sh | sh

#Subnet Router config:
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf


sudo tailscale up --auth-key=${tailscale_auth_key} # --advertise-routes=$PRIVATE_IP_32
