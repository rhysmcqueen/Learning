#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Set Private Subnet CIDR
PRIVATE_SUBNET_CIDR="${private_subnet_cidr}"

# Tailscale Installation and Configuration
curl -fsSL https://tailscale.com/install.sh | sh

# Subnet Router Configuration
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

sudo tailscale up --auth-key=${tailscale_auth_key} --advertise-routes=${private_subnet_cidr} --hostname=${tailscale_name}
+