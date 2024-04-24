#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  fgt_ports = {
    public  = "port1"
    private = "port2"
  }
  #-----------------------------------------------------------------------------------------------------
  # VPN HUBs variables
  #-----------------------------------------------------------------------------------------------------
  hub_id            = "HUB"
  hub_bgp_asn_hub   = "65001"           // iBGP RR server
  hub_bgp_asn_spoke = "65001"           // iBGP RR client
  hub_vpn_cidr      = "172.16.100.0/24" // VPN DialUp spokes cidr

  # Config VPN DialUps FGT HUB
  hub = [
    {
      id                = local.hub_id
      bgp_asn_hub       = local.hub_bgp_asn_hub
      bgp_asn_spoke     = local.hub_bgp_asn_spoke
      vpn_cidr          = local.hub_vpn_cidr
      vpn_psk           = var.vpn_psk
      cidr              = var.hub_vpc_cidr
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "public"
      local_gw          = ""
    }
  ]

  hub_public_ip  = module.hub.fgt_eip_public
  hub_private_ip = ""

  // Define SDWAN HUBs EU (Cloud+OnPremises) 
  hubs = [for hub in local.hub :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = hub["vpn_port"] == "public" ? local.hub_public_ip : local.hub_private_ip
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 0, 0), 1)
      site_ip           = hub["mode_cfg"] ? "" : cidrhost(cidrsubnet(hub["vpn_cidr"], 0), 3)
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 0, 0), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
}