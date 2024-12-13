#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --auth-key=${tailscale_auth_key}
