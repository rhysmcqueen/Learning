variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}


provider "aws" {
  region = "ca-west-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# Define SSH Key
resource "aws_key_pair" "keypair" {
  key_name     = "terraform-public-key-1"
  public_key   = file(var.public_key_file)
}

# Security group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow-ssh-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all; restrict as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "instance" {
  ami                 = "ami-0ba992fa05aaa4a76" # Amazon Linux AMI CA-WEST-1
  instance_type       = "t3.nano"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  key_name            = aws_key_pair.keypair.key_name
  user_data           = var.startup_script

  tags = {
    Name = "VirtualMachine-1"
  }
}
output "instance_names_and_ips" {
  description = "Names and public IPs of the EC2 instances"
  value = "${aws_instance.instance.tags["Name"]}: ${aws_instance.instance.public_ip}"
}