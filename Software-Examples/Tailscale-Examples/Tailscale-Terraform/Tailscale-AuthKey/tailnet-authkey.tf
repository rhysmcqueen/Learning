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

resource "tailscale_tailnet_key" "testing_key" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
  expiry        = 7776000 #In Seconds 7776000=90days
  description   = "Testing key"
  recreate_if_invalid = "always"
}

# Output the read-only attributes
output "key_id" {
  value = tailscale_tailnet_key.testing_key.id
}

output "created_at" {
  value = tailscale_tailnet_key.testing_key.created_at
}

output "expires_at" {
  value = tailscale_tailnet_key.testing_key.expires_at
}

output "invalid" {
  value = tailscale_tailnet_key.testing_key.invalid
}

output "key" {
  value = nonsensitive(tailscale_tailnet_key.testing_key.key)
  sensitive = true
}

output "clear_key" {
  description = "AuthKey: "
  value = nonsensitive(tailscale_tailnet_key.testing_key.key)
}