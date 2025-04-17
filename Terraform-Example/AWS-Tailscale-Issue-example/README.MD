# Overview

This Terraform configuration creates **3 EC2 Instances** in the default VPC and in the same subnet. Their private IP addresses are set so that they follow one another (calculated from the subnet CIDR):  
- **Host 1**: Subnet router with tailscale installed. In its startup script it enables IP forwarding, advertises the entire subnet, auto-approves routes, and runs an ethtool command to tune the network device.  
- **Host 2**: Tailscale node that simply accepts routes.  
- **Host 3**: A basic VM with Apache installed.

## Configuration Files

1. **Main Terraform File (main.tf):** Contains all the resource definitions and configurations.  
2. **Secrets File (secrets.tfvars):** Contains your [Tailscale Auth Key](https://login.tailscale.com/admin/settings/keys) and AWS credentials.  
3. **Variable File (variables.tf):** Contains the public SSH key file variable.

## Deployment

1. **Initialize Terraform:**

    ```bash
    terraform init
    ```

2. **Apply Terraform Configuration:**

    ```bash
    terraform apply -var-file="secrets.tfvars"
    ```

3. **Destroy Deployment: To remove all created resources:**

    ```bash
    terraform destroy -var-file="secrets.tfvars"
    ```

4. **Output**  
After applying, the public IP addresses of the instances will be output for your reference.
