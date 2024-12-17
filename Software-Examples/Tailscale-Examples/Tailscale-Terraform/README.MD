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

**Resources**
- [x] [tailscale_acl](https://github.com/rhysmcqueen/Learning/tree/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-ACL/tailnet-acl.tf)
- [x] [tailscale_contacts](https://github.com/rhysmcqueen/Learning/tree/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-Settings)
- [x] [tailscale_device_authorization](https://github.com/rhysmcqueen/Learning/tree/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Device-Authorization)
- [x] [tailscale_device_key](https://github.com/rhysmcqueen/Learning/tree/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailscale-DeviceKey)
- [x] [tailscale_device_subnet_routes](https://github.com/rhysmcqueen/Learning/blob/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Device-Subnet-Routes/tailscale-subnet-routes-Approval.tf)
- [x] [tailscale_device_tags](https://github.com/rhysmcqueen/Learning/blob/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-DeviceTag)
- [x] [tailscale_dns_nameservers](https://github.com/rhysmcqueen/Learning/blob/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-DNS/tailnet-dns.tf)
- [x] [tailscale_dns_preferences](https://github.com/rhysmcqueen/Learning/blob/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-DNS/tailnet-dns.tf_)
- [x] [tailscale_dns_search_paths](https://github.com/rhysmcqueen/Learning/blob/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-DNS/tailnet-dns.tf)
- [x] [tailscale_dns_split_nameservers](https://github.com/rhysmcqueen/Learning/blob/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-DNS/tailnet-dns.tf)
- [ ] tailscale_logstream_configuration  - Paid Feature
- [ ] tailscale_posture_integration - Paid Feature
- [x] [tailscale_tailnet_key](https://github.com/rhysmcqueen/Learning/tree/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailscale-AuthKey)
- [x] [tailscale_tailnet_settings](https://github.com/rhysmcqueen/Learning/tree/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-Settings)
- [x] [tailscale_webhook](https://github.com/rhysmcqueen/Learning/tree/main/Software-Examples/Tailscale-Examples/Tailscale-Terraform/Tailnet-Settings)

**Data Sources**
- [ ] tailscale_4via6
- [ ] tailscale_acl
- [ ] tailscale_device
- [ ] tailscale_devices
- [ ] tailscale_user
- [ ]  tailscale_users