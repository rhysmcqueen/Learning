variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "tailscale_auth_key" {}

provider "aws" {
  region     = "ca-west-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# Lookup the default VPC
data "aws_vpc" "default" {
  default = true
}

# Retrieve all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Choose the first subnet (all instances will share this subnet)
locals {
  subnet_id = element(data.aws_subnets.default.ids, 0)
}

# Get the selected subnet details (for accessing its CIDR block)
data "aws_subnet" "selected" {
  id = local.subnet_id
}

# SSH key is declared in variables.tf, so we just use it here.
resource "aws_key_pair" "keypair" {
  key_name   = "terraform-public-key-3"
  public_key = file(var.public_key_file)
}

# Security Group that allows SSH (22) and HTTP (80) access from anywhere
resource "aws_security_group" "allow_ssh_http" {
  name_prefix = "allow-ssh-http-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Host 1: Subnet Router with Tailscale, ethtool tuning, and subnet advertisement.
resource "aws_instance" "host1" {
  ami                    = "ami-0ba992fa05aaa4a76"  # Update as needed
  instance_type          = "t3.nano"
  subnet_id              = local.subnet_id
  private_ip             = cidrhost(data.aws_subnet.selected.cidr_block, 10)
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = aws_key_pair.keypair.key_name

  user_data = <<EOF
#!/bin/bash
# Set the hostname
sudo hostnamectl set-hostname host1

sudo yum update -y
sudo yum install -y ethtool

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Determine the primary network interface
NETDEV=$$(ip -o route get 8.8.8.8 | cut -f 5 -d ' ')

# Adjust ethtool settings on the network interface
sudo ethtool -K $${NETDEV} rx-udp-gro-forwarding on rx-gro-list off

# Enable IP forwarding for routing
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Retrieve metadata token
TOKEN=$$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Retrieve MAC address using token
MAC=$$(curl -H "X-aws-ec2-metadata-token: $${TOKEN}" -s http://169.254.169.254/latest/meta-data/mac)

# Get the subnet CIDR block using token
SUBNET_CIDR=$$(curl -H "X-aws-ec2-metadata-token: $${TOKEN}" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$${MAC}/subnet-ipv4-cidr-block)

# Bring up Tailscale: advertise the subnet and auto-approve routes.
sudo tailscale up --auth-key="${var.tailscale_auth_key}" --advertise-routes=$${SUBNET_CIDR} --accept-routes
EOF

  tags = {
    Name = "Host-1 (Subnet Router)"
  }
}

# Host 2: Tailscale node that simply accepts routes.
resource "aws_instance" "host2" {
  ami                    = "ami-0ba992fa05aaa4a76"
  instance_type          = "t3.nano"
  subnet_id              = local.subnet_id
  private_ip             = cidrhost(data.aws_subnet.selected.cidr_block, 20)
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = aws_key_pair.keypair.key_name

  user_data = <<EOF
#!/bin/bash
# Set the hostname
sudo hostnamectl set-hostname host2

sudo yum update -y

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Bring up Tailscale in accept-routes mode
sudo tailscale up --auth-key="${var.tailscale_auth_key}" --accept-routes
EOF

  tags = {
    Name = "Host-2 (Tailscale Node)"
  }
}

# Host 3: Basic VM with Apache (no Tailscale)
resource "aws_instance" "host3" {
  ami                    = "ami-0ba992fa05aaa4a76"
  instance_type          = "t3.nano"
  subnet_id              = local.subnet_id
  private_ip             = cidrhost(data.aws_subnet.selected.cidr_block, 30)
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = aws_key_pair.keypair.key_name

  user_data = <<EOF
#!/bin/bash
# Set the hostname
sudo hostnamectl set-hostname host3

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
EOF

  tags = {
    Name = "Host-3 (Basic VM)"
  }
}

# Output the public IP addresses of the instances
output "instance_names_and_ips" {
  description = "Public IP addresses of the EC2 instances"
  value = {
    Host1 = aws_instance.host1.public_ip,
    Host2 = aws_instance.host2.public_ip,
    Host3 = aws_instance.host3.public_ip
  }
}
