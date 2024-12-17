#!/bin/bash

#Metadata
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AMI_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/ami-id)
INSTANCE_TYPE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type)
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/placement/availability-zone)


sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
#Edit the Apache
cat <<EOF > /var/www/html/index.html
<html>
<head>
    <title>EC2 Instance Metadata</title>
</head>
<body>
    <h1>EC2 Instance Metadata</h1>
    <p>Instance ID: $INSTANCE_ID</p>
    <p>AMI ID: $AMI_ID</p>
    <p>Instance Type: $AZ</p>
    <p>Instance Type: $INSTANCE_TYPE</p>
</body>
</html>
EOF

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