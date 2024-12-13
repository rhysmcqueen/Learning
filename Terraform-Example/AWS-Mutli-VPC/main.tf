variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region = "ca-west-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
data "aws_availability_zones" "available" {}

# Define city names
variable "city_names" {
  default = ["Calgary", "Toronto", "Vancouver", "Montreal", "Banff", "Jasper", "Revelstoke"]
}

resource "aws_vpc" "vpc" {
  count             = var.num_of_cities
  cidr_block        = "10.${count.index + 1}.0.0/16" # Assigns 10.1.0.0/16, 10.2.0.0/16, etc.
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.city_names[count.index] # Use city names
  }
}

resource "aws_subnet" "subnet" {
  count             = var.num_of_cities
  vpc_id            = aws_vpc.vpc[count.index].id
  cidr_block        = "10.${count.index + 1}.0.0/24" # Assigns 10.1.0.0/24, 10.2.0.0/24, etc.
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.city_names[count.index]}-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  count  = var.num_of_cities
  vpc_id = aws_vpc.vpc[count.index].id

  tags = {
    Name = "${var.city_names[count.index]}-igw"
  }
}

resource "aws_route_table" "route_table" {
  count  = var.num_of_cities
  vpc_id = aws_vpc.vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }

  tags = {
    Name = "${var.city_names[count.index]}-route-table"
  }
}

resource "aws_route_table_association" "route_table_association" {
  count          = var.num_of_cities
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.route_table[count.index].id
}

resource "aws_security_group" "sg" {
  count  = var.num_of_cities
  vpc_id = aws_vpc.vpc[count.index].id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from the internet (Optional: Restrict based on IP)
  }

  tags = {
    Name = "${var.city_names[count.index]}-sg"
  }
}

resource "aws_key_pair" "keypair" {
  key_name     = "terraform-public-key"
  public_key   = file(var.public_key_file)
}

resource "aws_instance" "instance" {
  depends_on = [aws_security_group.sg]
  count               = var.num_of_cities
  ami                 = "ami-0ba992fa05aaa4a76" # Amazon Linux AMI CA-WEST-1
  instance_type       = "t3.nano"
  subnet_id           = aws_subnet.subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.sg[count.index].id] # Correct argument
  private_ip          = "10.${count.index + 1}.0.10"
  associate_public_ip_address = true
  key_name            = aws_key_pair.keypair.key_name
  user_data           = var.startup_script

  tags = {
    Name = "${var.city_names[count.index]}-instance"
  }
}

output "instance_names_and_ips" {
  description = "Names and public IPs of the EC2 instances"
  value = join("\n", [
    for instance in aws_instance.instance :
    "${instance.tags["Name"]}: ${instance.public_ip}"
  ])
}