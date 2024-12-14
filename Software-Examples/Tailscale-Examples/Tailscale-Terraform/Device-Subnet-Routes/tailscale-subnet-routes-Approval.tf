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

data "tailscale_device" "sample_device" {
  name = "calgary-instance.tail522858.ts.net"
}

resource "tailscale_device_subnet_routes" "sample_routes" {
  device_id = data.tailscale_device.sample_device.id
  routes = [
    "10.1.0.0/24",

  ]
}
#resource "tailscale_device_subnet_routes" "sample_exit_node" {
#  device_id = data.tailscale_device.sample_device.id
#  routes = [
#    # Configure as an exit node
#    "0.0.0.0/0",
#    "::/0"
#  ]
#}