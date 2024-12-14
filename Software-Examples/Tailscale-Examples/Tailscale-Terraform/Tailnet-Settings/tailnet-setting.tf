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

resource "tailscale_tailnet_settings" "sample_tailnet_settings" {
  devices_approval_on                         = true
  devices_auto_updates_on                     = true
  devices_key_duration_days                   = 7
  users_approval_on                           = true
  users_role_allowed_to_join_external_tailnet = "member"
  posture_identity_collection_on              = true
  # network_flow_logging_on                     = true    # NEED PREMIUM/PAID PLAN
  # regional_routing_on                         = true    # NEED PREMIUM/PAID PLAN
}
