## Notes about these Repos:

All Terraform files will reference your local public key when needed. Please store you public key as follows OR pass through a different location in the variable files
```bash
~/.ssh/id_rsa.pub
```
## How To Install Terraform on Ubuntu Server

[Terraform-Website]("https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli")

Update and Install Dependencies
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install terraform

```

## Some Terraform commands

### 1. Basic Commands

This command sets up the working directory with the necessary plugins and modules.
```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destory
```
### 2. Expanding on Terraform commands
A little extra meat on the bone for terraform commands:

#### Auto Approve

```bash
terraform apply --auto-approve
terraform destory --auto-approve
```

### Variables
Pass individual Variables: (If You pass variables here it will take precedence of the defaults set in the code)
```bash
terraform apply -var="variable_name=value"
```
Or pass a variable File/Secret File
```bash
terraform destroy -var-file="secrets.tfvars"
terraform destroy -var-file="secrets.tfvars"
```

### This is a working section will add more commands as I need ( Or as I forget them!)

