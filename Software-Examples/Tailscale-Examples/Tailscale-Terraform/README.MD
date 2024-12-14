With This learning I am going to try to configure everything through terraform. I create a brand new Tailscale Account learn.mcqueenlab@gmail.com and now I am going to test different scripts

[Tailscale Terraform Provider]("https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources")
### 0. Configure the Tailnet Setting
* Device Approval off (for now)
* Device Auto Update On
* device key duration = 7days
* user approval ON
* User role allowed to join external tailnet "member"

### 1. Set the Contact details for the account.
Since I dont check this email I want to change the contact email to my personal email so I am aware of any issues
### 2. Set the DNS Servers
Set the DNS servers to Cloudflare
### 2.1 Split DNS
After I set up my multi site tailscale network use split dns.

### 3. Make a Tailscale Auth Key and use said key in a script
Generate a Key and then use said key when deploying a AWS instance

### 4. Tailscale Device Authorization
Set the Tailnet to not allow new devices and then have the Device Authorization work. Maybe do this via a discord bot? That would be cool
