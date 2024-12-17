variable "tailscale_api_key" {}
variable "tailnet" {}

terraform {
  required_providers {
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.17.2"
    }
  }
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailnet
}


#This one works if you used 
# https://github.com/rhysmcqueen/Learning/tree/main/Terraform-Example/AWS-Single-EC2-Instance-Tailscale
# To make the vm! (Really all you need to do in change your device name and tailnet)
data "tailscale_device" "device_key" {
  name = "ip-172-31-17-63.tail522858.ts.net"
}

resource "tailscale_device_key" "device_key_expiry_disable" {
  device_id           = data.tailscale_device.device_key.id
  key_expiry_disabled = true
}