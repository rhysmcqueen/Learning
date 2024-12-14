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
# Commenting out since I dont want it to override local dns at this moment
# resource "tailscale_dns_nameservers" "nameservers" {
#  nameservers = [
#    "1.1.1.1",
#    "8.8.8.8"
#  ]
# }

resource "tailscale_dns_preferences" "magic_dns_preferences" {
  magic_dns = true
}

resource "tailscale_dns_search_paths" "domainname_search_paths" {
  search_paths = [
    "dropping-packet.com"
  ]
}

resource "tailscale_dns_split_nameservers" "calgary_split_dns_nameservers" {
  domain = "calgary.dropping-packet.com"

  nameservers = ["1.1.1.1"]
}
resource "tailscale_dns_split_nameservers" "toronto_split_dns_nameservers" {
  domain = "toronto.dropping-packet.com"

  nameservers = ["8.8.8.8"]
}

resource "tailscale_dns_split_nameservers" "vancouver_split_dns_nameservers" {
  domain = "vancouver.dropping-packet.com"

  nameservers = ["9.9.9.9"]
}