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

# resource "tailscale_acl" "jason_format" {
#   acl = jsonencode({
#     acls : [
#       {
#         // Allow all users access to all ports.
#         action = "accept",
#         users  = ["*"],
#         ports  = ["*:*"],
#       },
#     ],
#   })
# }

resource "tailscale_acl" "acl_code" {
  acl = <<EOF
{
  // Example/default ACLs for unrestricted connections.

  // Groups
  "groups": {
    "group:serveradmin": ["learn.mcqueenlab@gmail.com", "john@example.com"],
    "group:terraform":   ["learn.mcqueenlab@gmail.com", "john@example.com"]
  },

  // Define the tags which can be applied to devices and by which users.
  "tagOwners": {
    "tag:AWS":       ["autogroup:admin"],
    "tag:Terraform": ["autogroup:admin"],
    "tag:Testing":   ["autogroup:admin"]
  },

  // Define access control lists for users, groups, autogroups, tags,
  // Tailscale IP addresses, and subnet ranges.
  "acls": [
    // Allow all connections.
    // Comment this section out if you want to define specific restrictions.
    { "action": "accept", "src": ["*"], "dst": ["*:*"] }

    // Example: Allow users in "group:example" to access "tag:example" devices with posture checks.
    // { "action": "accept", "src": ["group:example"], "dst": ["tag:example:*"], "srcPosture": ["posture:autoUpdateMac"] }
  ],

  // Define users and devices that can use Tailscale SSH.
  "ssh": [
    {
      "action": "check",
      "src":    ["autogroup:member"],
      "dst":    ["autogroup:self"],
      "users":  ["autogroup:nonroot", "root"]
    }
  ]

  // Test access rules every time they're saved.
  // "tests": [
  //   {
  //     "src": "alice@example.com",
  //     "accept": ["tag:example"],
  //     "deny": ["100.101.102.103:443"]
  //   }
  // ]
}
EOF
}
