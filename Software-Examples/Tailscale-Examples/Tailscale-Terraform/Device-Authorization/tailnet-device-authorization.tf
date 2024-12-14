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

data "tailscale_device" "testing_device" {
  name = "ip-172-31-30-202.tail522858.ts.net"
}

resource "tailscale_device_authorization" "sample_authorization" {
  device_id  = data.tailscale_device.testing_device.id
  authorized = true
}